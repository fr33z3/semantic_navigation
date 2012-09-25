module SemanticNavigation
  module Core
    class Leaf < Base
      include UrlMethods
      include NameMethods

      attr_accessor :link_classes

      def initialize(options, level)
        super options, level
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
