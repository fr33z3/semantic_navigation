module SemanticNavigation
  module Core
    class Node < Navigation
      include UrlMethods
      include NameMethods

      attr_accessor :link_classes, :node_classes

      def initialize(options, level)
        @url = []
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
