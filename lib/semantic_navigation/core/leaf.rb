module SemanticNavigation
  module Core
    class Leaf < NavigationItem
      attr_accessor :link_classes, :link_html

      def initialize(options, level)
        @link_html = {}
        super options, level
      end

      def is_leaf?
        true
      end

      def mark_active
        if @url
          @active = urls.map{|u| current_page?(u) rescue false}.reduce(:"|")
        else
          @active = false
        end
      end

    end
  end
end
