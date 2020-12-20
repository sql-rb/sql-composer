# frozen_string_literal: true

module SQL
  module Builder
    module Nodes
      class Identifier
        attr_reader :name

        def initialize(name)
          @name = name
        end

        # this is probably a stupid idea lol
        def ==(other)
          Operations::Eql.new(self, other)
        end

        def to_s
          name
        end
      end
    end
  end
end
