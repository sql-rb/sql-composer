# frozen_string_literal: true

require "sql/composer/nodes/operators"

module SQL
  module Composer
    module Nodes
      class Qualified < Core
        include Operators

        def left
          fetch(:left)
        end

        def right
          fetch(:right)
        end

        def to_s
          [left, right].map(&:to_s).join(".")
        end

        def to_ast
          [:qualified, [left.to_ast, right.to_ast]]
        end
      end
    end
  end
end
