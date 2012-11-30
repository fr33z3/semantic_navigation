require "semantic_navigation/version"
require 'semantic_navigation/core'
require 'semantic_navigation/renderers'
require "semantic_navigation/configuration"
require 'semantic_navigation/railtie' if defined?(Rails)

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
      puts message.join("\n")
  	end
  end
end

