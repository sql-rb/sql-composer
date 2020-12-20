# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "sql/composer"
require "sql/composer/node_helpers"

begin
  require "byebug"
rescue LoadError
end

RSpec.configure do |config|
  config.include(SQL::Composer::NodeHelpers)
end
