additional_files = %w()
additional_files.each do |additional_file|
  require File.expand_path(File.dirname(__FILE__)+"semantic_navigation/#{addtional_file}")
end