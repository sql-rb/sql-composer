# frozen_string_literal: true

require "sql/composer/nodes/operations/eql"
require "sql/composer/nodes/operations/order_direction"

module SQL
  module Composer
    module Nodes
      module Operators
        def ==(other)
          value = Nodes::Value.new(input: other, backend: backend)

          operation = Operations::Eql.new(left: self, right: value)

          if other.start_with?("%") && other.end_with?("%")
            tokens.add(other, value)
          end

          operation
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
