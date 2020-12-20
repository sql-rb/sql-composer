# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class Where < Core
        def operations
          fetch(:operations)
        end

        def to_s
          "WHERE #{operations.map(&:to_s).join(' ')}"
        end
      end
    end
  end
end
