# frozen_string_literal: true

require "sql/composer/nodes/core"
require "sql/composer/nodes/literal"

module SQL
  module Composer
    module Nodes
      class Order < Core
        track true

        type :order

        def self.args_ast(*args)
          args.map { |arg|
            case arg
            when Hash
              arg.map { |key, value| Literal.new(value: key).public_send(value) }.map(&:to_ast)
            else
              [arg.to_ast]
            end
          }.flatten(1)
        end

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

        def to_ast
          [:order, operations.map(&:to_ast)]
        end
      end
    end
  end
end
