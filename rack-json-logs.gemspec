# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-json-logs/version'

Gem::Specification.new do |gem|
  gem.name          = 'rack-json-logs'
  gem.version       = Rack::JsonLogs::VERSION
  gem.authors       = ['Kenneth Ballenegger']
  gem.email         = ['kenneth@ballenegger.com']
  gem.description   = %q{Rack::JsonLogs is a gem that helps log sanely in production.}
  gem.summary       = %q{Rack::JsonLogs is a gem that helps log sanely in production.}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'json'
  gem.add_dependency 'colorize'
  gem.add_dependency 'optimist'
end
