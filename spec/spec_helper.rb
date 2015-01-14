require 'rspec'
require 'rails'
require 'action_view'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group "Core", "lib/semantic_navigation/core"
  add_group "Renderers", "lib/semantic_navigation/renderers"
  add_group "Twitter Bootstrap Renderer", "lib/semantic_navigation/twitter_bootstrap"
end

require 'semantic_navigation'

SemanticNavigation::Configuration.run do |c|
  c.display_deprecation_messages = false
end

RSpec.configure do |config|
  # throw config.methods.select{|s| s.to_s =~ /color/}
  config.color = true
  config.formatter     = 'documentation'
end
