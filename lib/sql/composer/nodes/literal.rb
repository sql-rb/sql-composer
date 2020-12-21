# frozen_string_literal: true

require "sql/composer/nodes/core"
require "sql/composer/nodes/operators"

module SQL
  module Composer
    module Nodes
      class Literal < Core
        include Operators

        def value
          fetch(:value)
        end
        alias_method :to_s, :value
      end
    end
  end
end
