module SemanticNavigation
  module Core
    module MixIn
      module ConditionMethods
        def has_active_children?
          sub_elements.map(&:active).any?
        end
      end
    end
  end
end
