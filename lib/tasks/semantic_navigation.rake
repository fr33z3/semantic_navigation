require 'ftools'

namespace :semantic_navigation do
  desc "The semantic navigation install"
  task :install => :environment do
    File.copy("#{File.dirname(__FILE__)}/templates/semantic_navigation.rb", "#{Rails.root}/config")
  end
  
  desc "Shows the menu hierarchy"
  task :show => :environment do
    puts "Here will be the navigation printout"
  end
end
