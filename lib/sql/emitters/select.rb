require 'sql/emitters/base'

module SQL
  module Emitters
    class Select < Base
      handles :select
      children :fields, :id

      def dispatch
        write 'SELECT '
        visit(fields)
        write ' FROM '
        visit(id)
      end
    end
  end
end
