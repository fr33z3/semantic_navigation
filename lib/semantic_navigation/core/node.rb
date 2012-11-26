module SemanticNavigation
  module Core
    class Node < Navigation
      include MixIn::UrlMethods
      include MixIn::NameMethods

      attr_accessor :link_classes, :node_classes,
                    :link_html, :node_html

      def initialize(options, level)
        @url = []
        @link_html = {}
        @node_html = {}
        super options, level
      end

      def mark_active
        @sub_elements.each{|element| element.mark_active}
        @active = urls.map{|u| current_page?(u) rescue false}.reduce(:"|")
        @active |= !@sub_elements.find{|element| element.active}.nil?
      end

    end
  end
end
