require 'sql/support/ast/processor'
require 'sql/emitters'

module SQL
  class Processor < AST::Processor
    register Emitters::And
    register Emitters::Select
    register Emitters::Id
    register Emitters::Eq
    register Emitters::Fields
    register Emitters::Integer
    register Emitters::Or
    register Emitters::String
    register Emitters::Where

    attr_reader :buffer

    def initialize(*args)
      super
      @buffer = ''
    end

    def call(*args)
      super
      buffer
    end
  end
end
