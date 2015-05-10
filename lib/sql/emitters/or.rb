require 'sql/emitters/base'

module SQL
  module Emitters
    class Or < Base
      handles :or

      def dispatch
        write '('
        delimited(*children, ' OR ')
        write ')'
      end

      def delimited(head, tail, delimiter)
        visit(head)
        write(delimiter)
        visit(tail)
      end
    end
  end
end
