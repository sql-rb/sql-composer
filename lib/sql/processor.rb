require 'sql/support/ast/processor'
require 'sql/emitters'

module SQL
  class Processor < AST::Processor
    register Emitters::Select
    register Emitters::Id
    register Emitters::Fields

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
