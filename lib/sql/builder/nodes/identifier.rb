# frozen_string_literal: true

require "sql/builder/nodes/core"

module SQL
  module Builder
    module Nodes
      class Identifier < Core
        def name
          fetch(:name).to_s
        end

        def to_s
          qualify? ? [qualifier, quote(name)].map(&:to_s).join(".") : quote(name)
        end

        def qualifier
          fetch(:qualifier)
        end

        def qualify?
          options.key?(:qualifier)
        end

        # this is probably a stupid idea lol
        def ==(other)
          Operations::Eql.new(self, other)
        end
      end
    end
  end
end
