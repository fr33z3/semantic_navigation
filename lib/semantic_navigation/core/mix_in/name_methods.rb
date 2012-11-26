module SemanticNavigation
  module Core
    module MixIn
      module NameMethods
        
        def name(renderer_name = nil)
          rendering_name = @name
          rendering_name = rendering_name[renderer_name.to_sym] || rendering_name[:default] if rendering_name.is_a?(Hash)
          rendering_name = view_object.instance_eval(&rendering_name).to_s if rendering_name.is_a?(Proc)
          rendering_name || i18n_name(renderer_name)
        end

        private

        def i18n_name(renderer_name = nil)
          name = I18n.t("#{@i18n_name}.#{@id}", :default => '')
          if name.is_a? Hash
            name = name[renderer_name.to_sym] || name[:default]
          end
          name || ''
        end      
      end
    end
  end
end