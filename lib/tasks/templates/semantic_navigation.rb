#This file need to create the navigation in your app.
SemanticNavigation::Configuration.run do |config|

  #What's the name of the active menu class will be (the dafault is 'active')
  config.active_class = 'active';
  
  #Create the menu ids automatically?
  config.create_ids = true
  
  #Show the submenu only when the menu is active
  config.show_submenu = true
  
  #That's how you can create your userbar menu
  #config.userbar do |userbar|
  #  userbar.signin :controller => :session, :action => :signin, :if => current_user.nil?
  #  userbar.signout :controller => :session, :action => :signout, :if => !current_user.nil?
  #end
  #so you can use the helper 'render_userbar_menu' to render it.

  #That's the creation of the navigation menu
  config.navigation #do |navigation|
    #navigation.first 'first', :controller => :first, :action => :act
    #navigation.second 'second', :controller => :second, :action => :act
  #end

end
