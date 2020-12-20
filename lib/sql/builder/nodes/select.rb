# frozen_string_literal: true

module SQL
  module Builder
    module Nodes
      class Select
        attr_reader :names

        def initialize(names)
          @names = names
        end

        def to_s
          "SELECT #{names.map(&:to_s).join(', ')}"
        end
      end
    end
  end
end
