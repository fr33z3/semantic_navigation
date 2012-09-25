### 0.1.0 
* Making register_renderer function to catch already registered renderer class by received symbol name
* Added scoping for items definitions

### 0.0.14 / August 29, 2012
* Now in render_if proc there is possibility to catch self(rendering element)
* Items accept procs for links definitions
* Fixed bug in active_item_for method
* active_item_for now returns empty string instead of nil then no active items
* added multiname support for items

### 0.0.13 / August 14, 2012

* Bugfixes for support array of route like links

### 0.0.12 / August 13, 2012

* Bug fixes in renderers
* Added possibility to pass an array of urls for one item

### 0.0.11 / August 4, 2012

* Added possibility to define urls in Rails routes way like 'namespace/controller#action'
* Removed empty `class` parameter for tags
* Added new semantic navigation configuration methods `header` and `divider`

### 0.0.10 / July 30, 2012

* Added Simple bootstrap navigation class
* Created aliases for renderers

### 0.0.9 / April 4, 2012

* Fixed bug with Proc names
* Breadcrumbs now support except_for
* Added render_if option to elements

### 0.0.8 / April 3rd, 2012

* New configuration logic
* New helper render method
* Reloadable in development, and caching in production
* I18n support
* Render config, can be set through helper render method
* Included support for custom renderers

### 0.0.6 / February 10th, 2012

* Now uses fileutils raver ftools for ruby-1.9.x
* Some fixes for ruby-1.9.x

### 0.1.0 / Januarry 9th, 2012

* Speed up the rendering

### 0.0.5 /Januarry 7th, 2012

* Bugfix for levels render

### 0.0.4 / Januarry 6th, 2012

* Added helper method wrapping the level 1 (root) render
* Fix breadcrumbs render
* Added helper method rendering menu from some level

### 0.0.3 / January 4th, 2012

* Added levels rendering
* Added menu classes

### 0.0.2.1 / December 30th, 2011

* Fix one bug with configuration

### 0.0.2 / December 30th, 2011

* Definition of default render options (active_class and show_ids)
* Definition of the private render options to each menu item
* Definition of default option that says render submenu always or only then parent is active
* Raise error on undefined helper methods calls
* Raise error on undefined menu render calls
* Added helper method to render active name item
* Added helper method to render active item parent name
* Changed helper method to render menu
* Added prefixes for menu, item, name ids
* Added conditions for rendering (function show_if)
* Added breadcrumbs rendering

### 0.0.1 / December 23th, 2011

* Initial release [Sergey Gribovski]
