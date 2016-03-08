%w(
base
mix_in/dsl_methods
mix_in/condition_methods
navigation
navigation_item
leaf
node
).each do |file|
  require "semantic_navigation/core/#{file}"
end
