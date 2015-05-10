require 'sql/emitters/base'

module SQL
  module Emitters
    class String < Base
      handles :string
      children :value

      def dispatch
        write %('#{value}')
      end
    end
  end
end
