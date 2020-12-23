# frozen_string_literal: true

require "delegate"

module SQL
  module Composer
    class Parenthesized < SimpleDelegator
      def to_s
        "(#{__getobj__})"
      end

      def to_ast
        [:parenthesis, __getobj__.to_ast]
      end
    end
  end
end
