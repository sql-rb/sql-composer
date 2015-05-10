require 'sql/emitters/base'

module SQL
  module Emitters
    class And < Base
      handles :and

      def dispatch
        write '('
        delimited(*children, ' AND ')
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
