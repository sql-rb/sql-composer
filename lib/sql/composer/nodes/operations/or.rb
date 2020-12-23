# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      module Operations
        class Or < Core
          def left
            fetch(:left)
          end

          def right
            fetch(:right)
          end

          def to_s
            "(#{left.to_s}) OR (#{right.to_s})"
          end

          def to_ast
            [:or, [left.to_ast, right.to_ast]]
          end
        end
      end
    end
  end
end
