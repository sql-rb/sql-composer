# frozen_string_literal: true

require "sql/composer/parenthesized"

module SQL
  module Composer
    class Statement
      include Enumerable

      attr_reader :options

      def initialize(options)
        @options = options
      end

      def each(&block)
        nodes.each(&block)
      end

      def append_to(type, *args, &block)
        node = by_type(type).append(*args, &block)
        rewrite(node)
      end

      def rewrite(node)
        self.class.new(compiler: compiler.rewrite(node))
      end

      def by_type(type)
        detect { |n| n.type.equal?(type) }
      end

      def in_parens
        Parenthesized.new(self)
      end

      def empty?
        nodes.empty?
      end

      def set(values)
        tokens = compiler.tokens.new

        values.each do |key, value|
          tokens.set(key, value)
        end

        compiler.with(tokens: tokens)
      end

      def to_s
        compiler.to_s
      end

      def compiler
        options.fetch(:compiler)
      end

      def nodes
        compiler.nodes
      end
    end
  end
end
