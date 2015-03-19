require 'sql/support/ast/emitter'

module SQL
  module Emitters
    class Base < AST::Emitter
      attr_reader :buffer

      def initialize(*args)
        super
        @buffer = processor.buffer
      end

      def write(string)
        buffer << string
      end
    end
  end
end
