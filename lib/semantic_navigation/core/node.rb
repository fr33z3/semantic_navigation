module SemanticNavigation
  module Core
    class Node < NavigationItem
      include MixIn::DslMethods
      include MixIn::ConditionMethods

      attr_accessor :link_classes, :node_classes,
                    :link_html, :node_html, :sub_elements

      def initialize(options, level)
        @url = []
        @link_html = {}
        @node_html = {}
        @scope_options = {}
        @sub_elements = []
        super options, level
      end

      def has_active_children?
        sub_elements.map(&:active).any?
      end

      def mark_active
        @sub_elements.each{|element| element.mark_active}
        @active = urls.map{|u| current_page?(u) rescue false}.reduce(:"|")
        @active |= !@sub_elements.find{|element| element.active}.nil?
      end

    end
  end
end
