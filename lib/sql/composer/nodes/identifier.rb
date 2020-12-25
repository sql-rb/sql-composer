# frozen_string_literal: true

require "sql/composer/nodes/core"
require "sql/composer/nodes/operators"

module SQL
  module Composer
    module Nodes
      class Identifier < Core
        include Operators

        def name
          fetch(:name).to_s
        end

        def to_s
          quote(name)
        end

        def to_ast
          [:identifier, name]
        end

        def asc
          Operations::Asc.new(self)
        end

        def desc
          Operations::Desc.new(self)
        end
      end
    end
  end
end
