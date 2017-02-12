# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "multimarkdown/version"

Gem::Specification.new do |s|
  s.name        = "multimarkdown-ffi"
  s.version     = Multimarkdown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jakob Kofoed Janot"]
  s.email       = ["jakob@janot.dk"]
  s.homepage    = "http://github.com/jakobjanot/multimarkdown-ffi"
  s.summary     = "A Multimarkdown 5 binding for Ruby using FFI"
  s.description = %q(Multimarkdown is a derivative of Markdown that adds new
                  syntax features, such as footnotes, tables, and metadata.)
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.licenses    = ['MIT']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- exe/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extensions    << 'ext/Rakefile'

  s.add_runtime_dependency 'ffi-compiler'
  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
end
