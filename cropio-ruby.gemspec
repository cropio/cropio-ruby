# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cropio/version'

Gem::Specification.new do |spec|
  spec.name          = "cropio-ruby"
  spec.version       = Cropio::VERSION
  spec.authors       = ["Sergey Vernidub"]
  spec.email         = ["info@cropio.com"]

  spec.summary       = %q{Cropio API bindings for Ruby}
  spec.description   = %q{Cropio-Ruby provides simple ActiveRecord-like wrappings for Cropio API}
  spec.homepage      = "https://cropio.com"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'json'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "byebug"
end
