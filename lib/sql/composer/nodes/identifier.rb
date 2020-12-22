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
      end
    end
  end
end
