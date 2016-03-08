module SemanticNavigation
  module Core
    class NavigationItem < Base

      def url
        urls.first
      end

      def skip?(renderer_name)
        renderer_name == skip_for
      end

      def name(renderer_name = nil)
        rendering_name = case @name
        when Hash
          @name[renderer_name.to_sym] || @name[:default]
        when Proc
          view_object.instance_eval(&@name).to_s
        when nil
          i18n_name(renderer_name)
        else
          @name
        end
      end

      private
      attr_reader :skip_for

      def urls
        [@url].flatten(1).map do |url|
          if url.is_a?(Proc)
            view_object.instance_eval(&url) rescue ""
          else
            url
          end
        end
      end

      def i18n_name(renderer_name = nil)
        name = I18n.t("#{@i18n_name}.#{@id}", default: "")
        name = name[renderer_name.to_sym] || name[:default] if name.is_a?(Hash)
        name || ""
      end
    end
  end
end
