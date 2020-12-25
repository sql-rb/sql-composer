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

      def append(type, *args, &block)
        new_dsl =
          if block
            dsl.new(&block)
          else
            dsl.new.__send__(type, *args)
          end

        left = self
        right = new_dsl.()

        left.merge(right)
      end

      def append_to(type, *args, &block)
        node = by_type(type).append(*args, &block)
        rewrite(node)
      end

      NODE_ORDER = %i[select from where order].freeze

      def merge(other)
        new_nodes = (nodes + other.nodes).group_by(&:type)

        new_ast = NODE_ORDER
          .map { |type|
            if (current = new_nodes[type])
              current.reduce(:merge)
            end
          }
          .compact
          .map { |node|
            node.dsl.with_tokens { node.to_ast }
          }

        new_dsl = dsl.new(ast: new_ast, tokens: dsl.tokens.merge(other.dsl.tokens))

        new_dsl.()
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

      def to_ast
        dsl.with_tokens { nodes.map(&:to_ast) }.last
      end

      def compiler
        options.fetch(:compiler)
      end

      def nodes
        compiler.nodes
      end

      def dsl
        compiler.dsl
      end
    end
  end
end
