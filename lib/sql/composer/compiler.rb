# frozen_string_literal: true

require "sql/composer/statement"
require "sql/composer/tokens"
require "sql/composer/nodes"

module SQL
  module Composer
    class Compiler
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
        with_tokens { ast.map { |node| visit(node) } }
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
        with_tokens { nodes.map(&:to_s).join(" ") }
      end

      def visit(node)
        visitor, rest = node
        __send__(:"visit_#{visitor}", rest)
      end

      def visit_literal(value)
        new_node(Nodes::Literal, value: value)
      end

      def visit_from(node)
        add_node(Nodes::From, source: visit(node))
      end

      def visit_select(node)
        add_node(Nodes::Select, identifiers: node.map { |n| visit(n) })
      end

      def visit_where(node)
        add_node(Nodes::Where, operations: node.map { |n| visit(n) })
      end

      def visit_eql(node)
        left, right = node
        new_node(Nodes::Operations::Eql, left: visit(left), right: visit(right))
      end

      def visit_value(node)
        _type, value = node
        new_node(Nodes::Value, input: value)
      end

      def visit_identifier(name)
        new_node(Nodes::Identifier, name: name)
      end

      def visit_qualified(node)
        left, right = node
        new_node(Nodes::Qualified, left: visit(left), right: visit(right))
      end

      def visit_aliased(node)
        left, right = node
        new_node(Nodes::Aliased, left: visit(left), right: visit(right))
      end

      def visit_order(node)
        add_node(Nodes::Order, operations: node.map { |n| visit(n) })
      end

      def visit_order_direction(node)
        target, direction = node
        visit(target).public_send(direction.downcase)
      end

      def visit_or(node)
        left, right = node
        new_node(Nodes::Operations::Or, left: visit(left), right: visit(right))
      end

      def with_tokens(&block)
        dsl.with_tokens(&block)
      end

      private

      def new_node(klass, options)
        klass.new(options.update(backend: backend, dsl: dsl))
      end

      def add_node(klass, options)
        nodes << new_node(klass, options)
        self
      end
    end
  end
end
