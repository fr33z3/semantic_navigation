module SemanticNavigation
  module Core
    class Node < Navigation      
      attr :link_classes, :node_classes
      
      def url
        @url.is_a?(Array) ? @url.first : @url
      end
      
      def initialize(options, level)
        @url = []
        super options, level
      end
      
      def name
        rendering_name = @name || i18n_name
        if rendering_name.is_a?(Proc)
          view_object.instance_eval(&rendering_name).to_s
        else
          rendering_name
        end
      end
      
      def mark_active
        @sub_elements.each{|element| element.mark_active}
        @active = [@url].flatten(1).map{|u| current_page?(u) rescue false}.reduce(:"|")
        @active |= !@sub_elements.find{|element| element.active}.nil?
      end
            
      private
      
      def i18n_name
        I18n.t("#{@i18n_name}.#{@id}", :default => '')
      end
      
    end
  end
end
