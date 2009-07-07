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

spec = Gem::Specification.new do |s|
  s.name = "text-hatena"
  s.version = "0.12.20080627.0"
  s.summary = "A Ruby library for Hatena notation"
  s.require_path = 'lib'
  s.files = (Dir.glob('{lib,t}/**/*').select{|i|File.file?(i)} + %w(README README.en README.rdoc Rakefile) + ["#{s.name}.gemspec"]).sort
  s.has_rdoc = true
  s.author = 'Hiroyuki Iwatsuki'
  s.email = 'don@na.rim.or.jp'
  s.homepage = 'http://moonrock.jp/~don/ruby/text-hatena/'
end
Rake::GemPackageTask.new(spec) do |t|
  t.need_tar = true
  t.gem_spec = spec
end

desc "Generate gemspec"
task :gemspec do
  File.open("#{spec.name}.gemspec", "w") do |f|
    f.flock(File::LOCK_EX)
    f.write(spec.to_yaml)
  end
end

desc "Install #{spec.name}-#{spec.version}"
task :install => :package do
  sh %(sudo gem install pkg/#{spec.name}-#{spec.version})
end

desc "Uninstall #{spec.name}"
task :uninstall do
  sh %(sudo gem uninstall #{spec.name})
end
