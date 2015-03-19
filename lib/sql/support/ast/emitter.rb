require 'ast'

module SQL
  module AST
    class Emitter
      include ::AST::Sexp

      def self.handles(name = nil)
        if name
          @type = name
        else
          @type
        end
      end

      def self.children(*names)
        names.each_with_index do |name, index|
          define_method(name) do
            children.at(index)
          end
        end
      end

      def self.type
        @type
      end

      def self.call(*args)
        new(*args).call
      end

      attr_reader :processor, :node, :parent, :children

      def initialize(processor, node, parent)
        @processor = processor
        @node = node
        @parent = parent
        @children = node.children
      end

      def visit(other)
        processor.emitters[other.type].call(processor, other, node)
      end

      def call
        dispatch
        node
      end

      def process(node)
        processor.call(node, self)
      end
    end
  end
end
