require 'fileutils'

namespace :semantic_navigation do
  desc "The semantic navigation install"
  task :install => :environment do
    File.copy("#{File.dirname(__FILE__)}/templates/semantic_navigation.rb", "#{Rails.root}/config")
  end
end
