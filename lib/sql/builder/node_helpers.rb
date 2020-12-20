# frozen_string_literal: true

require "sql/builder/nodes"

module SQL
  module Builder
    module NodeHelpers
      def sql_identifier(name)
        Nodes::Identifier.new(name)
      end
    end
  end
end
