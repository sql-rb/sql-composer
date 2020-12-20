# frozen_string_literal: true

require "sql/builder/nodes/core"

module SQL
  module Builder
    module Nodes
      class Select < Core
        def identifiers
          fetch(:identifiers)
        end

        def to_s
          "SELECT #{identifiers.map(&:to_s).join(', ')}"
        end
      end
    end
  end
end
