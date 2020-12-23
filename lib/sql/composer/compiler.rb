# frozen_string_literal: true

require "sql/composer/statement"
require "sql/composer/tokens"
require "sql/composer/nodes"

module SQL
  module Composer
    class Compiler
      include ::Dry::Effects::Handler.State(:tokens)

      attr_reader :backend

      attr_reader :nodes

      attr_reader :options

      attr_reader :tokens

      attr_reader :dsl

      def initialize(backend, options)
        @backend = backend
        @options = options
        @nodes = options[:nodes] || []
        @tokens = options[:tokens]
        @dsl = options[:dsl]
      end

      def call(ast)
        with_tokens(tokens) { ast.map { |node| visit(node) } }
        Statement.new(compiler: freeze)
      end

      def rewrite(node)
        new_nodes = nodes.map { |n| n.id.equal?(node.id) ? node : n }
        self.class.new(backend, options.merge(nodes: new_nodes))
      end

      def with(new_options)
        self.class.new(backend, options.merge(new_options).merge(nodes: nodes))
      end

      def to_s
        with_tokens(tokens) { nodes.map(&:to_s).join(" ") }.last
      end

      def visit(node)
        visitor, *args = node
        __send__(:"visit_#{visitor}", args)
        self
      end

      def visit_literal(node)
        add_node(Nodes::Literal, value: node[0])
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
        nodes << klass.new(options.update(backend: backend, dsl: dsl))
        self
      end
    end
  end
end
