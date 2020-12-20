# frozen_string_literal: true

module SQL
  module Builder
    module Nodes
      class From
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def to_s
          "FROM #{name.to_s}"
        end
      end
    end
  end
end
