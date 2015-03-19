module SQL
  module AST
    class Processor
      class << self
        attr_reader :emitters
      end

      def self.inherited(processor)
        processor.instance_variable_set('@emitters', {})
      end

      def self.register(emitter)
        emitters[emitter.type] = emitter
      end

      def self.call(ast)
        new(emitters).call(ast)
      end

      attr_reader :emitters

      def initialize(emitters)
        @emitters = emitters
      end

      def call(node, parent = nil)
        loop do
          type = node.type
          emitter = emitters[type]

          if emitter
            node = emitter.call(self, node, parent)

            break if type == node.type
          else
            break
          end
        end

        node
      end
    end
  end
end
