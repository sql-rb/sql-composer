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
        @ast = []
        @tokens = options[:tokens] || Tokens.new

        with_tokens(tokens) do
          instance_exec(*options[:args], &block)
        end
      end

      def inspect
        "#<SQL::Composer::DSL ast=#{ast.inspect}>"
      end

      def new(&block)
        ::SQL::Composer::DSL.new(options.merge(tokens: nil), &block)
      end

      def call
        compiler = Compiler.new(options.fetch(:backend), dsl: self, tokens: tokens)
        compiler.(ast)
      end

      def lit(value)
        with_tokens(tokens) {
          Nodes::Literal.new(value: value, backend: options[:backend])
        }.last
      end
      alias_method :`, :lit

      private

      def method_missing(name, *args)
        ast << [name.to_s.downcase, *args]
        self
      end
    end
  end
end
