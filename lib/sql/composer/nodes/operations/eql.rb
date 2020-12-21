# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      module Operations
        class Eql < Core
          def left
            fetch(:left)
          end

          def right
            fetch(:right)
          end

          def or(other)
            Operations::Or.new(left: self, right: other)
          end
          alias_method :OR, :or

          def to_s
            "#{left.to_s} = #{right.to_s}"
          end
        end
      end
    end
  end
end
