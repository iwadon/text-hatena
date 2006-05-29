# -*- Ruby -*-

require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "."
  t.pattern = "t/test*.rb"
end
