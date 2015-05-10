require 'sql/emitters/base'

module SQL
  module Emitters
    class Where < Base
      handles :where

      def dispatch
        write ' WHERE '
        children.each do |child|
          visit(child)
        end
      end
    end
  end
end
