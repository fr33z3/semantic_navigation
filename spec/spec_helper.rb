require 'rails'
require 'rspec'
require 'semantic_navigation'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
