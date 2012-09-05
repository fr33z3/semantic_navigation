module SemanticNavigation
  module Core
    class Base

      attr_accessor :id, :level, :classes, :active
      attr_writer :render_if

      def render_if
        !@render_if.nil? ? view_object.instance_exec(self, &@render_if) : true
      end

      def initialize(options, level)
        @level = level
        options.keys.each do |option_name|
          instance_variable_set :"@#{option_name}", options[option_name]
        end
      end

      def render(renderer)
        class_name = self.class.name.split('::').last.downcase
        renderer.send :"render_#{class_name}", self
      end

      private

      def view_object
        SemanticNavigation::Configuration.view_object
      end

      def current_page?(options = {})
       result = true
        if options.is_a? Hash
          options.each do |key, value|
            result &= (view_object.params[key.to_sym].to_s == value.to_s)
          end
        else
          result = view_object.current_page? options
        end
        result
      end

    end
  end
end
