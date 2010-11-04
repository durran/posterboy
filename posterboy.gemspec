# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "posterboy/version"

Gem::Specification.new do |s|
  s.name        = "posterboy"
  s.version     = Posterboy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Durran Jordan"]
  s.email       = ["durran@gmail.com"]
  s.homepage    = "http://github.com/durran/posterboy"
  s.summary     = "PostgreSQL Search Done Easy"
  s.description = "Adds full-text search to Active Record models on PostgreSQL"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "posterboy"

  s.add_dependency("pg", ["~> 0.9"])
  s.add_dependency("activerecord", ["~> 3"])

  s.add_development_dependency("mocha", ["= 0.9.8"])
  s.add_development_dependency("rspec", ["~> 2.0"])
  s.add_development_dependency("watchr", ["= 0.7"])
  s.add_development_dependency("ruby-debug-wrapper", ["= 0.0.1"])

  s.files        = Dir.glob("lib/**/*") + %w(MIT_LICENSE README)
  s.require_path = 'lib'
end
