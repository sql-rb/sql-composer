# frozen_string_literal: true

require "sql/builder/nodes"

module SQL
  module Builder
    module NodeHelpers
      def sql_identifier(name, options = {})
        Nodes::Identifier.new(options.merge(name: name))
      end
    end
  end
end
