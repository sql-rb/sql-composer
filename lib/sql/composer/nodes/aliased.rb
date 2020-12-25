# frozen_string_literal: true

module SQL
  module Composer
    module Nodes
      class Aliased < Core
        def left
          fetch(:left)
        end

        def right
          fetch(:right)
        end

        def to_s
          "#{left} AS #{right}"
        end

        def to_ast
          [:aliased, [left.to_ast, right.to_ast]]
        end
      end
    end
  end
end
