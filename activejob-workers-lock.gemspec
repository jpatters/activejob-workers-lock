# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activejob/workers_lock/version'

Gem::Specification.new do |s|
  s.name          = "activejob-workers-lock"
  s.version       = Activejob::WorkersLock::VERSION
  s.authors       = ["jpatters"]
  s.email         = ["jordan@jpatterson.me"]
  s.summary       = %q{Adapt resque-workers-lock to work with ActiveJob}
  s.description   = ''
  s.homepage      = 'http://github.com/jpatters/activejob-workers-lock'
  s.license       = "MIT"

  s.files         = %w( README.md Rakefile Gemfile LICENSE.txt )
  s.files         += Dir.glob("lib/**/*")
  s.files         += Dir.glob("test/**/*")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'activejob', '>= 4.2'
  s.add_dependency 'activesupport', '~> 4.2'
  s.add_dependency "resque-workers-lock", "~> 2.0"

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"

  s.add_development_dependency "rails"
  s.add_development_dependency "sqlite3"
end
