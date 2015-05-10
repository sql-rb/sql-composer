require 'sql/emitters/base'

module SQL
  module Emitters
    class Integer < Base
      handles :integer
      children :value

      def dispatch
        write value.to_s
      end
    end
  end
end
