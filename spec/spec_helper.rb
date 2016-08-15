require "active_model"
require "simplecov"

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "unique_item_attributes_validator"
