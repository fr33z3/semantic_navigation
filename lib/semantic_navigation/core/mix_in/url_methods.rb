module SemanticNavigation
  module Core
    module MixIn
      module UrlMethods

        def url
          urls.first
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
end
