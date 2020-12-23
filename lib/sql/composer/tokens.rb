# frozen_string_literal: true

module SQL
  module Composer
    class Tokens
      include Dry::Core::Constants

      attr_reader :data

      attr_reader :counter

      attr_reader :options

      def initialize(options = {})
        @data = options[:data] || {}
        @counter = options[:counter] || 0
        @options = options.merge(data: data, counter: counter)
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

      def new(new_options = {})
        self.class.new(options.merge(new_options))
      end

      def merge(other)
        new(data: data.merge(other.data), counter: (counter + other.counter))
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
