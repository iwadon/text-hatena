# -*- Ruby -*-

require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require "rake/testtask"

task :default => :test

Rake::RDocTask.new do |t|
  t.rdoc_dir = 'rdoc'
  t.rdoc_files.include('README.en', 'lib/**/*.rb')
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

PKG_NAME = 'text-hatena'
PKG_VERS = '0.12.20061117.1'
spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERS
  s.summary = "A module for using Hatena text format"
  s.require_path = 'lib'
  s.files = Dir.glob('{lib,test}/**/*')
  s.has_rdoc = true
end
Rake::GemPackageTask.new(spec) do |t|
  t.need_tar = true
  t.gem_spec = spec
end
task :install => :package do
  sh %(sudo gem install pkg/#{PKG_NAME}-#{PKG_VERS})
end
task :uninstall do
  sh %(sudo gem uninstall #{PKG_NAME})
end
