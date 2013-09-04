# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rclife/version'

Gem::Specification.new do |spec|
  spec.name          = 'rclife'
  spec.version       = RCLife::VERSION
  spec.authors       = ['jmccance']
  spec.email         = ['jmccance@gmail.com']
  spec.description   = %q{"Ruby + Curses" Life}
  spec.summary       = %q{An implementation of Conway's Game of Life with Ruby and Curses.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'ruby-prof'
end
