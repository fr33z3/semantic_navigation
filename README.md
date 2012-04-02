This is semantic_navigation

Current version: 0.0.6

###Purpose
This gem generates the navigation for your Rails app.
Really customizable and simple to use.
Using this gem you have 4 types of renderers: menu, breadcrumb, tabs, and, pills

You can define different menus and render them separatelly.

Now with simple integration with a twitter-bootstrap css framework.

###How to install

Write the gem dependency in your Gemfile:
<pre><code>
gem 'semantic_navigation'
</code></pre>

Make the install by bundler
<pre><code>
$ bundle install
</code></pre>

Generate the config file:
<pre><code>
$ rails generate semantic_navigation:install
</code></pre>

###Quick start

Configure your navigation in config/semantic_navigation.rb

<pre><code>
SemanticNavigation::Configuration.run do
  navigate :root_menu do
    item :header_item, nil, :name => 'Header'
    item :first_item, '#', :name => 'First Item', :ico => :tag
    item :divide
    item :second_item, '#', :name => 'Second Item', :ico => :user
  end
end
</code></pre>

And try to render it in your layout(code in haml):
.well
  = navigation_for :root_menu, :as => :bootstrap_list

Render the navigation using the semantic_navigation helper methods and options for them.

For the information of how to configure and render your navigation read the <a href='https://github.com/fr33z3/semantic_navigation/wiki'>Wiki</a>