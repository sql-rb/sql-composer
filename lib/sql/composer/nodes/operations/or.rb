# frozen_string_literal: true

module SQL
  module Composer
    module Nodes
      module Operations
        class Or
          attr_reader :left, :right

          def initialize(left, right)
            @left, @right = left, right
          end

          def to_s
            "(#{left.to_s}) OR (#{right.to_s})"
          end
        end
      end
    end
  end
end
