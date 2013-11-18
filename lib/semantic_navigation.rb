require "semantic_navigation/version"
require 'semantic_navigation/core'
require 'semantic_navigation/renderers'
require "semantic_navigation/configuration"
require 'semantic_navigation/railtie' if defined?(Rails)
require 'colorize'

module SemanticNavigation

  def self.deprecation_message(type, deprecated_object, new_object, action = nil)
    if SemanticNavigation::Configuration.display_deprecation_messages
      message = ["DEPRECATION WARNING:",
                 "You are using deprecated #{type} `#{deprecated_object}`"]
      if action
        message[-1] += " for #{action}."
      else
        message[-1] += '.'
      end
      message += ["That #{type} will be depreacted soon.",
                  "Please use `#{new_object}` instead."]
      puts message.join("\n").red
    end
  end

  def self.actual_config_location
    locations =  ["#{Rails.root}/config/initializers/semantic_navigation.rb", 
                  "#{Rails.root}/config/semantic_navigation.rb",
                  "#{Rails.root}/app/navigation/semantic_navigation.rb"]
    
    actual_location = locations.find{|l| File.exists?(l)}
    raise ["Please create a semantic_navigation configuration",
           "(rails g semantic_navigation:install)", 
           "file before starting the project!"].join(" ") unless actual_location
    deprecation_message("file path", actual_location, locations.last) if actual_location != locations.last
    actual_location
  end

end

