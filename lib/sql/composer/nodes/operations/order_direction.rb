# frozen_string_literal: true

module SQL
  module Composer
    module Nodes
      module Operations
        class OrderDirection
          attr_reader :source

          def initialize(source)
            @source = source
          end

          def to_s
            "#{source.to_s} #{direction}"
          end

          def to_ast
            [:order_direction, [source.to_ast, direction]]
          end
        end

        class Asc < OrderDirection
          def direction
            "ASC"
          end
        end

        class Desc < OrderDirection
          def direction
            "DESC"
          end
        end
      end
    end
  end
end
