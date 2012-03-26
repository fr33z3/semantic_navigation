module SemanticNavigation
  module Core
    class Base      
      
      attr :id, :level, :classes, :active
      
      def initialize(options, level)
        @level = level
        options.keys.each do |option_name|
          instance_variable_set :"@#{option_name}", options[option_name]
          instance_eval "
            unless defined?(#{option_name})
              #{self.class}.class_eval '
                def #{option_name}
                  @#{option_name}
                end
              '
            end
          "
        end
      end

      def render(renderer)
        class_name = self.class.name.split('::').last.downcase
        renderer.send :"render_#{class_name}", self
      end
      
    end    
  end
end
