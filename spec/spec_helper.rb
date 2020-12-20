# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "sql/builder"
require "sql/builder/node_helpers"

begin
  require "byebug"
rescue LoadError
end

RSpec.configure do |config|
  config.include(SQL::Builder::NodeHelpers)
end
