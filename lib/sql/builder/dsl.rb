# frozen_string_literal: true

require "sql/builder/compiler"

module SQL
  module Builder
    class DSL < BasicObject
      attr_reader :options

      attr_reader :ast

      def initialize(options, &block)
        @ast = []
        @options = options
        instance_exec(*options[:args], &block)
      end

      def call
        compiler = Compiler.new(options.fetch(:backend))
        compiler.(ast)
      end

      def method_missing(name, *args)
        ast << [name, *args]
        self
      end
    end
  end
end
