# frozen_string_literal: true

require "delegate"

module SQL
  module Composer
    class Aliased < SimpleDelegator
      attr_reader :aliaz

      alias_method :node, :__getobj__

      def initialize(node, aliaz)
        super(node)
        @node = node
        @aliaz = aliaz
      end

      def to_s
        "#{node} AS #{aliaz}"
      end
    end
  end
end
