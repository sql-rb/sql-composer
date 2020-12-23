# frozen_string_literal: true

require "sql/composer/nodes/core"
require "sql/composer/nodes/operators"
require "sql/composer/nodes/aliasable"

module SQL
  module Composer
    module Nodes
      class Literal < Core
        include Operators
        prepend Aliasable

        def value
          fetch(:value)
        end
        alias_method :to_s, :value

        def to_ast
          [:literal, value]
        end
      end
    end
  end
end
