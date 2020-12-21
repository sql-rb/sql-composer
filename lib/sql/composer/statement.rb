# frozen_string_literal: true

module SQL
  module Composer
    class Statement
      include Enumerable

      attr_reader :options

      def initialize(options)
        @options = options
      end

      def each(&block)
        nodes.each(&block)
      end

      def set(values)
        tokens = compiler.tokens.new

        values.each do |key, value|
          tokens.set(key, value)
        end

        compiler.with(tokens: tokens)
      end

      def to_s
        compiler.to_s
      end

      def compiler
        options.fetch(:compiler)
      end

      def nodes
        compiler.nodes
      end
    end
  end
end
