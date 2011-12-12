# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "semantic_navigation/version"

Gem::Specification.new do |s|
  s.name        = "semantic_navigation"
  s.version     = SemanticNavigation::VERSION
  s.authors     = ["Sergey Gribovski"]
  s.email       = ["megacoder@rambler.ru"]
  s.homepage    = ""
  s.summary     = %q{Simplify the creation of navigation in the rails app}
  s.description = %q{Simplify the creation of navigation in the rails app}

  s.rubyforge_project = "semantic_navigation"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
   s.add_development_dependency "rspec", "2.7.0"
   s.add_runtime_dependency "rails", "~>3.1.0"
end
