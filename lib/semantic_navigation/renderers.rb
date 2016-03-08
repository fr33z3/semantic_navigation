%w(
renderers/mix_in/render_helpers
renderers/mix_in/acts_as_list
renderers/mix_in/acts_as_breadcrumb
renderers/list
renderers/bread_crumb
twitter_bootstrap/breadcrumb
twitter_bootstrap/list
twitter_bootstrap/tabs
twitter_bootstrap_3/breadcrumb
twitter_bootstrap_3/list
twitter_bootstrap_3/tabs
).each do |file|
  require "semantic_navigation/#{file}"
end
