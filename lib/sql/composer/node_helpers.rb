# frozen_string_literal: true

require "sql/composer/nodes"

module SQL
  module Composer
    module NodeHelpers
      def sql_identifier(name, options = {})
        id = Nodes::Identifier.new(options.merge(name: name))

        if (qualifier = options[:qualifier])
          Nodes::Qualified.new(left: qualifier, right: id)
        else
          id
        end
      end
    end
  end
end
