required_files = %w(base
                    url_methods
                    name_methods
                    navigation
                    leaf node)
required_files.each do |file|
  require "semantic_navigation/core/#{file}"
end
