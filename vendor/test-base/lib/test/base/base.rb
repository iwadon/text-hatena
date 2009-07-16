
require 'pathname'
require 'test/unit/testcase'

class Test::Base < Test::Unit::TestCase
end

require 'test/base/version'
require 'test/base/test_base_error'
require 'test/base/block'
require 'test/base/spec_parser'
require 'test/base/filters'
require 'test/base/util/backtrace_filter'

class Test::Base

  module Assertions 
    include Test::Unit::Assertions
    include Test::Base::Util::BacktraceFilter
  end
  include Assertions

  class Error < Test::Unit::Error
    include Test::Base::Util::BacktraceFilter
  end

  include Test::Base::Filters
  include Test::Base::Util::BacktraceFilter

  def initialize(block)
    @test_block = block
    @test_passed = true
    @filters = []
  end
  attr_accessor :filters

  def run(result)
    yield(STARTED, name)
    @_result = result
    begin
      setup
      @test_block.blocknize!(self)

      run_method_re = /^@run_/
      method_names = self.class.instance_variables.select {|m| m.match(run_method_re)}.map {|m| m.sub(run_method_re, '')}
      method_names.each do |method_name|
        args = self.class.instance_variable_get("@run_#{method_name}")
        args = args.map {|m| @test_block[m]}
        __send__("assert_#{method_name}", *args)
      end

      run_tests @test_block if respond_to?(:run_tests)
    rescue Test::Unit::AssertionFailedError => e
      add_failure(e.message, e.backtrace)
    rescue Test::Base::Block::ApplyFilterError => e
      add_error(e)
    #rescue NoMethodError => e # TODO impl
    #  add_error(e)
    rescue Exception
      raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
      add_error($!)
    ensure
      begin
        teardown
      rescue Test::Unit::AssertionFailedError => e
        add_failure(e.message, e.backtrace)
      rescue Exception
        raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
        add_error($!)
      end
    end
    result.add_run
    yield(FINISHED, name)
  end

  def name
    "#{@test_block.name}(#{self.class.name})"
  end

  def add_error(exception)
    @test_passed = false
    @_result.add_error(Error.new(name, exception))
  end
  private :add_error

  class << self
    attr_writer :spec_string, :spec_file
    attr_accessor :spec_source
    alias_method :spec_file, :spec_file=
    alias_method :spec_string, :spec_string=
    
    def delimitors(*args)
      if args.empty?
        @delimitors
      else
        @delimitors = args.flatten.first(2)
      end
    end

    def filters(fts = nil)
      @all_filter ||= []
      @filters ||= {}
      if fts.kind_of? Array
        @all_filter += fts
      elsif fts.kind_of? Hash
        @filters.update fts
      elsif !fts.nil?
        raise ArgumentError.new("filter arguments is Array or Hash")
      else
        @filters
      end
    end

    def suite
      suite = Test::Unit::TestSuite.new(name)

      if self < Test::Base
        # TODO spec 適用の優先順位
        unless @spec_source
          if @spec_string
            @spec_source = @spec_string
          elsif @spec_file
            path = Pathname.new(@spec_file)
            if path.exist?
              path.open('r'){|f| self.spec_source = f.read}
            else
              raise TestBaseError.new("spec not fount: #{@spec_file}")
            end
          else
            raise TestBaseError.new('spec not fount')
          end
        end

        SpecParser.new(@spec_source, @delimitors).each_block do |block|
          base = new block
          base.filters = @all_filter || []
          suite << base
        end
      end

      return suite
    end

    private
    def inherited_with_load_spec(subclass)
      assert_re = /^assert_/
      chech_methods = public_instance_methods(true) + private_instance_methods(true)
      run_methods = chech_methods.sort.uniq.select {|m| m.match(assert_re) }.map {|m| m.to_s.sub(assert_re, '') }
      run_methods.each do |run_method|
        subclass.class_eval <<-EOF
          def self.run_#{run_method}(*args)
            @run_#{run_method} = args
          end
        EOF
      end

      if respond_to?(:inherited_without_load_spec, true)
        inherited_without_load_spec(subclass) 
      end

      subclass.class_eval <<-EOF
        def base_binding
          binding
        end
      EOF

      begin
        path = Pathname.new(caller.first.split(':').first)
        if path.exist?
          spec_source = nil
          path.open('r'){|f| spec_source = f.read }
          end_re = /^__END__\r?\n/ 
          if spec_source.match(end_re)
            path.open('r'){|f| subclass.spec_source = f.read.split(end_re).last }
          end
        end
      end
    end
    alias_method :inherited_without_load_spec, :inherited
    alias_method :inherited, :inherited_with_load_spec
  end
end
