# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class Where < Core
        type :where

        track true

        def operations
          fetch(:operations)
        end

        def append(hash = {}, &block)
          new_operations = hash.map { |k, v| dsl.lit(k) == v }

          if block
            new_operations += dsl.new(&block).().by_type(:where).operations
          end

          with(operations: operations + new_operations)
        end

        def to_s
          "WHERE #{operations.map(&:to_s).join(' AND ')}"
        end
      end
    end
  end
end
