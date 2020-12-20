# frozen_string_literal: true

require "sql/composer/nodes"

module SQL
  module Composer
    module NodeHelpers
      def sql_identifier(name, options = {})
        Nodes::Identifier.new(options.merge(name: name))
      end
    end
  end
end
