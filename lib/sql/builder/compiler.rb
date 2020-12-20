# frozen_string_literal: true

module SQL
  module Builder
    class Compiler
      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def call(ast)
        ast.map { |node| visit(node) }
        freeze
      end

      def to_s
        nodes.map(&:to_s).join("\n")
      end

      def visit(node)
        visitor, *args = node
        __send__(:"visit_#{visitor}", args)
        self
      end

      def visit_from(node)
        name, _ = node
        nodes << Nodes::From.new(name)
        self
      end

      def visit_select(names)
        nodes << Nodes::Select.new(names)
        self
      end

      def visit_where(ops)
        nodes << Nodes::Where.new(ops)
        self
      end
    end
  end
end
