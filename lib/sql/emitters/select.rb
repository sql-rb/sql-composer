require 'sql/emitters/base'

module SQL
  module Emitters
    class Select < Base
      handles :select
      children :fields, :id, :where

      def dispatch
        write 'SELECT '
        visit(fields)
        write ' FROM '
        visit(id)
        visit(where)
      end
    end
  end
end
