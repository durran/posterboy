require "bundler"
Bundler.setup

require "rake"
require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "posterboy/version"

task :build do
  system "gem build posterboy.gemspec"
end

task :install => :build do
  system "sudo gem install posterboy-#{Posterboy::VERSION}.gem"
end

task :release => :build do
  system "git tag -a #{Posterboy::VERSION} -m 'Tagging #{Posterboy::VERSION}'"
  system "git push --tags"
  system "gem push posterboy-#{Posterboy::VERSION}.gem"
end

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
