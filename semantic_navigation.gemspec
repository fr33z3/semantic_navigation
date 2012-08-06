# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "semantic_navigation/version"

Gem::Specification.new do |s|
  s.name        = "semantic_navigation"
  s.version     = SemanticNavigation::VERSION
  s.authors     = ["Sergey Gribovski"]
  s.email       = ["megacoder@rambler.ru"]
  s.homepage    = "https://github.com/fr33z3/semantic_navigation"
  s.summary     = %q{Make the navigation in your Rails app by several lines}
  s.description = %q{Simply and customizable navigation in the Ruby on Rails 3 application.
                     Predefined bootstrap renderers}

  s.rubyforge_project = "semantic_navigation"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
   s.add_development_dependency "rspec", ">=2.0.1"
   s.add_development_dependency "simplecov"
   s.add_runtime_dependency "rails", ">=3.0.0"
end
