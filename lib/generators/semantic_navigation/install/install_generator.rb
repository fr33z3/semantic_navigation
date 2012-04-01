module SemanticNavigation
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator creates config file for your navigation"
      
      def add_semantic_navigation
        puts <<-EOM
        +===============================================================+
        |              SemanticNavigation install                       |
        | Please read the Wiki to learn how to define your navigation.  |
        | http://github.com/fr33z3/semantic_navigation/wiki.            |
        +===============================================================+
        EOM
        copy_file "semantic_navigation.rb", "config/semantic_navigation.rb"
        copy_file "semantic_navigation.en.yml", "config/locales/semantic_navigation.en.yml"
      end
    end
  end
end
