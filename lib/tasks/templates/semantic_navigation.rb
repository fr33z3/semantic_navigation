#This file need to create the navigation in your app.
SemanticNavigation::Configuration.run do |config|

  #That's the creation of the navigation menu
  config.navigation do |n|
    n.main 'Main', :controller => :dashboard, :action => :index
    n.about 'About', :controller => :about, :action => :index do |a|
      a.company 'About company', :controller => :about, :action => :company
      a.employes 'About our employes', :controller => :about, :action => :employes
    end
    n.feed_back 'Feedback', :controller => :feed_back, :action => :index
  end
  #You can render this menu by calling method render_navigation_menu

end
