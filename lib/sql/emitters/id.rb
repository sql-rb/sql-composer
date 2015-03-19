require 'sql/emitters/base'

module SQL
  module Emitters
    class Id < Base
      handles :id
      children :value

      def dispatch
        write %("#{value}")
      end
    end
  end
end
