# frozen_string_literal: true

require "sql/Composer/nodes/core"

module SQL
  module Composer
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
          Operations::Eql.new(self, Nodes::Value.new(input: other, backend: backend))
        end
      end
    end
  end
end
