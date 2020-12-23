# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class Order < Core
        track true

        type :order

        def operations
          fetch(:operations)
        end

        def append(hash = {}, &block)
          new_operations = hash.map { |k, v| dsl.lit(k).public_send(v) }

          if block
            new_operations += dsl.new(&block).().by_type(:order).operations
          end

          with(operations: operations + new_operations)
        end

        def to_s
          "ORDER BY #{operations.map(&:to_s).join(', ')}"
        end
      end
    end
  end
end
