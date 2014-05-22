module SemanticNavigation
  module Core
    module MixIn
      module ConditionMethods

        def skip_for_renderer
          @skip_for
        end

        def skip?(renderer_name)
          renderer_name == skip_for_renderer
        end

      end
    end
  end
end