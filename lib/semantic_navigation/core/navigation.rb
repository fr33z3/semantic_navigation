module SemanticNavigation
  module Core
    class Navigation < Base
      include MixIn::DslMethods
      include MixIn::ConditionMethods

      attr_accessor :sub_elements

      def initialize(options)
        @sub_elements = []
        @scope_options = {}
        super options, 0
      end

      def is_root?
        true
      end

      def mark_active
        @active = sub_elements.map do |element|
          element.mark_active
        end.any?
      end

    end
  end
end
