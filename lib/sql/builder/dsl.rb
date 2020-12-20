# frozen_string_literal: true

require "sql/builder/compiler"

module SQL
  module Builder
    class DSL < BasicObject
      attr_reader :ast

      def initialize(*args, &block)
        @ast = []
        instance_exec(*args, &block)
      end

      def call
        compiler = Compiler.new
        compiler.(ast)
      end

      def method_missing(name, *args)
        ast << [name, *args]
        self
      end
    end
  end
end
