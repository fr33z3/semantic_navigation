%w(
base
mix_in/url_methods
mix_in/name_methods
mix_in/dsl_methods
mix_in/condition_methods
navigation
leaf
node
).each do |file|
  require "semantic_navigation/core/#{file}"
end
