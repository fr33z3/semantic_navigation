# semantic_navigation

Simple navigation menus implementation for Rails 3 application with multiple and nesting menus.

## Purpose

Forget fat layouts, views and controllers. This gem will do all the menu staff for you.
You simply just have to generate configuration file, fill it with your menu hierarchy and renderer it wherever you want.

Simply and customizable it will make for you all the routins you were spending a lot of time before.

### Features

* semantic_navigation supports defining as many separate menus as you want and they can be as deep as you need.
* supports different styles of url definitions ('route#like', :symbols, 'strings', {hash: 'like'})
* supports and array of urls for one item
* supports procs for item name definitions - so you can have dynamic names
* supports render conditions defined as proc where you have access to controller class variables, request params and even to the rendering item
* supports multiname definitions where you can set the custom name for each renderer.
* has renderers compatible with bootstrap - so if you using bootstrap it will be simplier
* supports controller default styles overriding both - from configuration and view file
* supports custom renderers

## How to install

Write the gem dependency in your Gemfile:

```ruby
gem 'semantic_navigation'
```

Make the install by bundler

```bash
$ bundle install
```

Generate the config file:
```bash
$ rails generate semantic_navigation:install
```

## Quick start

Configure your navigation in `config/initializers/semantic_navigation.rb`:

```ruby
SemanticNavigation::Configuration.run do
  navigate :root_menu do
    header :header_item, :name => 'Header'
    item :first_item, '#', :name => 'First Item', :ico => :tag
    divider
    item :second_item, '#', :name => 'Second Item', :ico => :user
  end
end
```

And try to render it in your layout(code in haml):

```haml
.well
  = navigation_for :root_menu, :as => :bootstrap_list
```

or

```haml
.well
  = bootstrap_list_for :root_menu
```

Render the navigation using the semantic_navigation helper methods and options for them.

For the information of how to configure and render your navigation read the [Wiki](https://github.com/fr33z3/semantic_navigation/wiki).

### Dependencies

* Ruby >= 1.9.2
* Rails >= 3.0.0

