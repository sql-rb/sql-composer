# frozen_string_literal: true

require "sql/Composer/nodes/core"

module SQL
  module Composer
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
