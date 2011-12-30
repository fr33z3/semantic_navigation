#This file need to create the navigation in your app.
#You can learn more about how to customize your menu reading the wiki
#Wiki pages link: https://github.com/fr33z3/semantic_navigation/wiki/_pages
SemanticNavigation::Configuration.run do |config|

  #What's the name of the active menu class will be (the dafault is 'active')
  #config.active_class = 'active';
  
  #Do you want to show active class? (default = true)
  #config.show_active_class = true
  
  #Create the item ids (in the `li` tag) automatically (default = true)?
  #config.show_item_id = true
  
  #Create the menu ids (in the `ul` tag) automatically (default = true)?
  #config.show_menu_id = true
  
  #Create the name id (in the `a` tag) automatically (default = true)?
  #config.show_name_id = true
  
  #Show the submenu only when the menu is active (default = false)
  #config.show_submenu = false
  
  #Add menu prefix (`ul` tag)
  #config.menu_prefix = 'menu_'
  
  #Add item prefix (`li` tag)
  #config.item_prefix = 'item_'
  
  #Add name preifx (`a` tag)
  #config.name_prefix = 'name_'
  
  #Define breadcrumb divider
  #config.breadcrumb_divider = "<span class ='divider'>/</span>"
  
  #Define bread crumb classes
  #config.breadcrumb_classes = "breadcrumb"
  
  #That's the creation of the `navigation` menu
  #config.navigation {|n|
  #  n.dashboard 'Dashboard', :controller => :dashboard, :action => :index do |d|
  #    d.first 'First', :controller => :first, :action => :index do |f|
  #      f.sub_first 'Sub First', sub_first_index_path
  #      f.sub_second 'Sub Second', :controller => :sub_second, :action => :index
  #    end
  #  end
  #  n.second 'Help', :controller => :second, :action => :index
  #}

end
