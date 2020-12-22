# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "sql/composer"
require "sql/composer/node_helpers"

begin
  require "byebug"
rescue LoadError
end

module Test
  class UsersRelation
    include SQL::Composer::NodeHelpers

    def qualifier
      sql_identifier(:users, backend: SQL::Composer.backends[:postgres])
    end
    alias_method :table, :qualifier

    def id
      sql_identifier(:id, qualifier: qualifier, backend: SQL::Composer.backends[:postgres])
    end

    def name
      sql_identifier(:name, qualifier: qualifier, backend: SQL::Composer.backends[:postgres])
    end
  end

  module Helpers
    def compose(&block)
      SQL.compose(args: UsersRelation.new, &block)
    end
  end
end

RSpec.configure do |config|
  config.include(SQL::Composer::NodeHelpers)
  config.include(Test::Helpers)
end
