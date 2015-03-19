require 'ast'

require 'sql/processor'
require 'sql/version'

module SQL
  module NodeHelper
    def s(type, *children)
      ::AST::Node.new(type, children)
    end
  end

  def self.[](ast)
    Processor.call(ast)
  end
end
