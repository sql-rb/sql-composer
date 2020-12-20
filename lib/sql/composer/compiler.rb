# frozen_string_literal: true

module SQL
  module Composer
    class Compiler
      attr_reader :backend

      attr_reader :nodes

      def initialize(backend)
        @backend = backend
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
        source, _ = node
        add_node(Nodes::From, source: source)
      end

      def visit_select(nodes)
        add_node(Nodes::Select, identifiers: nodes)
      end

      def visit_where(node)
        add_node(Nodes::Where, operations: node)
      end

      def visit_order(node)
        add_node(Nodes::Order, operations: node)
      end

      private

      def add_node(klass, options)
        nodes << klass.new(options.update(backend: backend))
        self
      end
    end
  end
end
