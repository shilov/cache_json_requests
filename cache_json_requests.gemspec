# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cache_json_requests/version'

Gem::Specification.new do |spec|
  spec.name          = "cache_json_requests"
  spec.version       = CacheJsonRequests::VERSION
  spec.authors       = ["Stanley Shilov"]
  spec.email         = ["stanleyshilov@gmail.com"]
  spec.description   = %q{Action caching of JSON requests using Redis}
  spec.summary       = %q{Action caching of JSON requests using Redis}
  spec.homepage      = "https://github.com/shilov/cache_json_requests"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "redis"
end
