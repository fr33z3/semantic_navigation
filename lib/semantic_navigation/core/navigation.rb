module SemanticNavigation
  module Core
    class Navigation < Base
      include MixIn::DslMethods

      attr_accessor :sub_elements

      def initialize(options)
        @sub_elements = []
        @scope_options = {}
        super options, 0
      end

      def mark_active
        @sub_elements.each do |element|
          element.mark_active
        end
        @active = !@sub_elements.find{|element| element.active}.nil?
      end

    end
  end
end
