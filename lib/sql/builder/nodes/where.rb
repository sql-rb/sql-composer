# frozen_string_literal: true

module SQL
  module Builder
    module Nodes
      class Where
        attr_reader :ops

        def initialize(ops)
          @ops = ops
        end

        def to_s
          "WHERE #{ops.map(&:to_s).join(' ')}"
        end
      end
    end
  end
end
