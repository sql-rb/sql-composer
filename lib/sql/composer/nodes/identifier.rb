# frozen_string_literal: true

require "sql/composer/nodes/core"

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

        def asc
          Operations::Asc.new(self)
        end

        def desc
          Operations::Desc.new(self)
        end

        def qualifier
          fetch(:qualifier)
        end

        def qualify?
          options.key?(:qualifier)
        end

        # this is probably a stupid idea lol
        def ==(other)
          value = Nodes::Value.new(input: other, backend: backend)

          operation = Operations::Eql.new(left: self, right: value)

          if other.start_with?("%") && other.end_with?("%")
            tokens.add(other, value)
          end

          operation
        end
      end
    end
  end
end
