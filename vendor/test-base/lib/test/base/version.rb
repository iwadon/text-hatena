require 'test/base/base'

module Test::Base::VERSION
  unless defined?(MAJOR)
    MAJOR = 0
    MINOR = 0
    TINY  = 1
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end
