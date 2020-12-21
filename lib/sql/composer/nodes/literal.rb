# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class Literal < Core
        def value
          fetch(:value)
        end
        alias_method :to_s, :value
      end
    end
  end
end
