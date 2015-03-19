$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sql.rb'

begin
  require 'byebug'
rescue LoadError
end

RSpec.configure do |config|
  config.include(SQL::NodeHelper)
end
