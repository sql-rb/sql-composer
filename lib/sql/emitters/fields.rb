require 'sql/emitters/base'

module SQL
  module Emitters
    class Fields < Base
      handles :fields

      def dispatch
        delimited(children, ', ')
      end

      def delimited(nodes, delimiter)
        head, *tail = nodes
        visit(head)
        tail.each do |node|
          write(delimiter)
          visit(node)
        end
      end
    end
  end
end
