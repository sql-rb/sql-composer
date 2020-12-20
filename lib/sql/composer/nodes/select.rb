# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
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
