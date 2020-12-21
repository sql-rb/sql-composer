# frozen_string_literal: true

module SQL
  module Composer
    class Tokens
      include Dry::Core::Constants

      attr_reader :data

      def initialize(data: {}, counter: 0)
        @data = data
        @counter = counter
      end

      def add(key, node)
        data[key[1..-2].to_sym] = [node.id, Undefined]
        self
      end

      def set(key, value)
        tuple = [data[key][0], value]
        data[key] = tuple
        self
      end

      def new
        self.class.new(data: data.dup, counter: @counter)
      end

      def value(id, default)
        entry = data.detect { |_, (node_id, value)| node_id.equal?(id) }
        entry ? entry[1][1] : default
      end

      def next_id
        @counter += 1
      end
    end
  end
end
