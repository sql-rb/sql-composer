# frozen_string_literal: true

require "sql/builder/dsl"

module SQL
  def self.build(*args, &block)
    Builder::DSL.new(*args, &block).()
  end
end
