# frozen_string_literal: true

require "sql/composer/compiler"

module SQL
  module Composer
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
        ast << [name.to_s.downcase, *args]
        self
      end
    end
  end
end
