# -*- Ruby -*-

require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require "rake/testtask"

task :default => :test

Rake::RDocTask.new do |t|
  t.rdoc_dir = 'rdoc'
  t.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
  t.options << '--charset' << 'utf-8'
  t.template = 'kilmer'
end
  
Rake::TestTask.new do |t|
  t.pattern = "t/test*.rb"
end

begin
  require "rcov/rcovtask"
  Rcov::RcovTask.new do |t|
    t.libs << "."
    t.pattern = "t/test*.rb"
  end
rescue LoadError
end

spec = Gem::Specification.load("text-hatena.gemspec")
Rake::GemPackageTask.new(spec) do |t|
  t.need_tar = true
  t.gem_spec = spec
end

desc "Install #{spec.name}-#{spec.version}"
task :install => :package do
  sh %(sudo gem install pkg/#{spec.name}-#{spec.version})
end

desc "Uninstall #{spec.name}"
task :uninstall do
  sh %(sudo gem uninstall #{spec.name})
end
