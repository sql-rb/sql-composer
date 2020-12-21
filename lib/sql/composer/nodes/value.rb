# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class Value < Core
        def input
          tokens.value(id, fetch(:input))
        end

        def to_s
          backend.escape(input)
        end
      end
    end
  end
end
