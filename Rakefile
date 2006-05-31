# -*- Ruby -*-

require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "."
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
