module SemanticNavigation
  class Configuration

    @@bootstrap_version = 2

    @@navigations = {}
    @@renderers = {}
    @@render_styles = {}

    cattr_accessor :view_object do
      nil
    end

    cattr_accessor :display_deprecation_messages do
      true
    end

    def self.run(&block)
      self.class_eval &block if block_given?
    end

    def self.navigate(id, options = {}, &block)
      options[:id] = id.to_sym
      options[:i18n_name] = "semantic_navigation.#{id}"
      navigation = Core::Navigation.new(options)
      navigation.instance_eval &block if block_given?
      @@navigations[id.to_sym] = navigation
    end

    def render(menu_id, renderer_name, options, view_object)
      @@view_object = view_object
      renderer = @@renderers[renderer_name].new
      unless @@render_styles[renderer_name].nil?
        renderer.instance_eval &@@render_styles[renderer_name]
      end
      options.keys.each{|key| renderer.send "#{key}=", options[key]}
      renderer.name = renderer_name
      navigation = @@navigations[menu_id]
      navigation.mark_active
      navigation.render(renderer)
    end

    def self.styles_for(name)
      @@render_styles[name.to_sym] = proc
    end

    def self.register_renderer(*options)
      if options.count == 1
        name = options[0].name.demodulize.underscore.to_sym
        renderer_class = options[0]
      elsif options.count == 2
        name = options[0].to_sym
        renderer_class = options[1].is_a?(Symbol) ? @@renderers[options[1]] : options[1]
      end
      @@renderers[name] = renderer_class
      SemanticNavigation::HelperMethods.class_eval "
        def #{name}_for(name, options = {})
          options[:as] = :#{name}
          navigation_for name, options
        end
      "
    end

    def self.navigation(name)
      @@navigations[name]
    end

    def self.bootstrap_version(version=nil)
      if version
        @@bootstrap_version = version
      else
        @@bootstrap_version
      end
    end

    def self.navigation_current_item(navigation_name, level)
      navigation = self.navigation(navigation_name)
      navigation.mark_active
      item = navigation
      while !item.is_leaf? && item.has_active_children? &&
            (!level.nil? ? item.level < level : true)
        item = item.sub_elements.find{|e| e.active}
      end
      item
    end

    def self.navigation_current_level(navigation_name)
      item = navigation_current_item(navigation_name, nil)
      item.try(:level) || -1
    end

  end
end
