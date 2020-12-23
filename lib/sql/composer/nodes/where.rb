# frozen_string_literal: true

require "sql/composer/nodes/core"
require "sql/composer/nodes/literal"

module SQL
  module Composer
    module Nodes
      class Where < Core
        type :where

        track true

        def self.args_ast(*args)
          args.map { |arg|
            case arg
            when Hash
              arg.map { |key, value| Literal.new(value: key) == value }.map(&:to_ast)
            else
              [arg.to_ast]
            end
          }.flatten(1)
        end

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

        def to_ast
          [:where, operations.map(&:to_ast)]
        end

        def to_s
          "WHERE #{operations.map(&:to_s).join(' AND ')}"
        end
      end
    end
  end
end
