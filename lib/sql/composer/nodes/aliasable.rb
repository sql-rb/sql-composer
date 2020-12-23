# frozen_string_literal: true

require "sql/composer/aliased"

module SQL
  module Composer
    module Nodes
      module Aliasable
        def as(aliaz)
          Aliased.new(self, aliaz)
        end
        alias_method :AS, :as
      end
    end
  end
end
