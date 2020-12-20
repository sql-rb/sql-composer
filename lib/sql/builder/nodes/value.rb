# frozen_string_literal: true

require "sql/builder/nodes/core"

module SQL
  module Builder
    module Nodes
      class Value < Core
        def input
          fetch(:input)
        end

        def to_s
          backend.escape(input)
        end
      end
    end
  end
end
