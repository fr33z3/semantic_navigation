module SemanticNavigation
  module Generators
    class ListRendererGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator creates list like rendering class"

      def generate_list_renderer
        template "list_renderer.rb", "app/models/renderers/#{file_name}.rb"
      end

      def register_renderer
        semantic_navigation_config = SemanticNavigation.actual_config_location
        register_string = "  register_renderer :#{file_name}, Renderers::#{class_name}\n"
        inject_into_file semantic_navigation_config, register_string, :after => "SemanticNavigation::Configuration.run do\n"
      end
    end
  end
end
