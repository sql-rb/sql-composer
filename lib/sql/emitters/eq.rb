require 'sql/emitters/base'

module SQL
  module Emitters
    class Eq < Base
      handles :eq

      def dispatch
        delimited(*children, ' = ')
      end

      def delimited(head, tail, delimiter)
        visit(head)
        write(delimiter)
        visit(tail)
      end
    end
  end
end
