# frozen_string_literal: true

require "dry/effects"

require "sql/composer/compiler"
require "sql/composer/tokens"
require "sql/composer/nodes/literal"

module SQL
  module Composer
    class DSL < BasicObject
      include ::Dry::Effects::Handler.State(:tokens)

      attr_reader :options

      attr_reader :ast

      attr_reader :tokens

      def initialize(options, &block)
        @options = options
        @ast = options[:ast] || []
        @tokens = options[:tokens] || Tokens.new

        with_tokens do
          instance_exec(*options[:args], &block)
        end if block
      end

      def inspect
        "#<SQL::Composer::DSL ast=#{ast.inspect}>"
      end

      def new(new_options = {}, &block)
        ::SQL::Composer::DSL.new(options.merge(new_options).merge(tokens: nil), &block)
      end

      def merge(other)
        new(ast: (ast + other.ast), tokens: tokens.merge(other.tokens))
      end

      def call
        compiler = Compiler.new(options.fetch(:backend), dsl: self, tokens: tokens)
        compiler.(ast)
      end

      def lit(value)
        Nodes::Literal.new(value: value, backend: options[:backend])
      end
      alias_method :`, :lit

      def select(*args)
        with_tokens { ast << [:select, Nodes::Select.args_ast(*args)] }
        self
      end
      alias_method :SELECT, :select

      def where(*args)
        with_tokens { ast << [:where, Nodes::Where.args_ast(*args)] }
        self
      end
      alias_method :WHERE, :where

      def order(*args)
        with_tokens { ast << [:order, Nodes::Order.args_ast(*args)] }
        self
      end
      alias_method :ORDER, :order

      def from(identifier)
        ast << [:from, identifier.to_ast]
        self
      end
      alias_method :FROM, :from

      def with_tokens(&block)
        super(tokens, &block).last
      end
    end
  end
end
