module SemanticNavigation
  module Core
    class Leaf < Base
      attr_accessor :link_classes
      
      def url
        urls.first
      end

      def initialize(options, level)
        super options, level
      end
      
      def name
        rendering_name = @name || I18n.t("#{@i18n_name}.#{@id}", :default => '')
        if rendering_name.is_a?(Proc)
          view_object.instance_eval(&rendering_name).to_s
        else
          rendering_name
        end
      end
      
      def mark_active
        if @url
          @active = urls.map{|u| current_page?(u) rescue false}.reduce(:"|")
        else
          @active = false
        end
      end

      private

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
