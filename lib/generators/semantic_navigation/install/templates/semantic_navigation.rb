#encoding: utf-8
SemanticNavigation::Configuration.run do
  # Read wiki https://github.com/fr33z3/semantic_navigation/wiki to lear about
  # semantic_navigation configuration
  
  #Override renderer default styles:
  #styles_for :list do
  #  show_navigation_active_class true
  #  navigation_active_class [:some_active_class]
  #end
  
  # You can register your custom renderer:
  #register_renderer :some_renderer, SomeRendererClass
  
  # The example of the navigation:
  #navigate :navigation do
  #  header :header_item, :name => 'Header Item'
  #  item :first_item, :first_item_route, :ico => 'user' do 
  #    item :sub_item, :sub_item_route do
  #      item :sub_sub_item, :sub_sub_item_route
  #    end
  #    item :second_sub, :second_sub_route, :ico => 'user'
  #  end
  #  divider
  #  item :second_item, :second_item_route
  #end
  
end

