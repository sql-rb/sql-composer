# frozen_string_literal: true

require "sql/builder/nodes/core"

module SQL
  module Builder
    module Nodes
      class From < Core
        def source
          fetch(:source)
        end

        def to_s
          "FROM #{source.to_s}"
        end
      end
    end
  end
end
