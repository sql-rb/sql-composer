# frozen_string_literal: true

require "sql/composer/nodes/core"
require "sql/composer/nodes/operators"
require "sql/composer/nodes/aliasable"

module SQL
  module Composer
    module Nodes
      class Literal < Core
        include Operators
        include Aliasable

        def value
          fetch(:value)
        end
        alias_method :to_s, :value
      end
    end
  end
end
