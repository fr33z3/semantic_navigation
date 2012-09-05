module SemanticNavigation
  module Core
    class Node < Navigation
      attr_accessor :link_classes, :node_classes

      def url
        urls.first
      end

      def initialize(options, level)
        @url = []
        super options, level
      end

      def name(renderer_name = nil)
        rendering_name = @name
        rendering_name = rendering_name[renderer_name.to_sym] || rendering_name[:default] if rendering_name.is_a?(Hash)
        rendering_name = view_object.instance_eval(&rendering_name).to_s if rendering_name.is_a?(Proc)
        rendering_name || i18n_name(renderer_name)
      end

      def mark_active
        @sub_elements.each{|element| element.mark_active}
        @active = urls.map{|u| current_page?(u) rescue false}.reduce(:"|")
        @active |= !@sub_elements.find{|element| element.active}.nil?
      end

      private

      def i18n_name(renderer_name = nil)
        name = I18n.t("#{@i18n_name}.#{@id}", :default => '')
        if name.is_a? Hash
          name = name[renderer_name.to_sym] || name[:default]
        end
        name || ''
      end

      def urls
        [@url].flatten(1).map do |url|
          if url.is_a?(Proc)
            view_object.instance_eval(&url) rescue ''
          else
            url
          end
        end
      end

    end
  end
end
