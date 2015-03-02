module SemanticNavigation
  module Core
    module MixIn
      module DslMethods

        def item(id, url=nil, options={}, &block)
          options[:id] = id.to_sym
          options[:render_if] = [*@render_if, options[:render_if], *@scope_render_if].compact

          if url.is_a?(Array)
            options[:url] = [url].flatten(1).map{|url| scope_url_params(decode_url(url))}
          else
            options[:url] = scope_url_params(decode_url(url))
          end

          options[:i18n_name] = @i18n_name

          if block_given?
            element = Node.new(options, @level+1)
            element.instance_eval &block
          else
            element = Leaf.new(options, @level+1)
            #Deprecation warning message
            #TODO:Should be deleted after moving the header and divider definition via item
            if element.url.nil? && !element.name.empty?
              SemanticNavigation.deprecation_message(:method,
                                                     'item',
                                                     'header',
                                                     'header definition')
            elsif element.url.nil? && element.name.empty?
              SemanticNavigation.deprecation_message(:method,
                                                     'item',
                                                     'header',
                                                     'divider definition')
            end
          end

          @sub_elements.push element
        end

        def header(id, options={})
          options[:id] = id.to_sym
          options[:render_if] = [options[:render_if], *@scope_render_if].compact
          options[:url] = nil
          options[:i18n_name] = @i18n_name
          @sub_elements.push Leaf.new(options, @level+1)
        end

        def divider(options = {})
          options[:id] = :divider
          options[:render_if] ||= [options[:render_if], *@scope_render_if].compact
          options[:url] = nil
          options[:i18n_name] = nil
          options[:name] = nil
          @sub_elements.push Leaf.new(options, @level+1)
        end

        def method_missing(m,*args,&block)
          if m.to_s.match(/^[_]+$/).to_a.size > 0
            divider
          else
            super(m,args,&block)
          end
        end

        def scope(options = {}, &block)
          @scope_url ||= options[:url]
          (@scope_render_if ||= []).push options[:render_if]

          self.instance_eval &block

          @scope_render_if.pop
          @scope_url = {}
        end

        private

        def scope_url_params(url)
          if url.is_a? Hash
          	(@scope_url || {}).merge(url)
          else
          	url
          end
        end

        def decode_url(url)
          if url.is_a? String
            controller_name, action_name = url.split('#')
            if controller_name && action_name
              decoded_url = {:controller => controller_name, :action => action_name}
            end
          end
          decoded_url || url
        end

      end
    end
  end
end