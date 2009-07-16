require 'test/base/base'
require 'test/base/util/backtrace_filter'

class Test::Base::Block < Hash
  class ApplyFilterError < Test::Base::TestBaseError; end
  include Test::Base::Util::BacktraceFilter

  def initialize(*args)
    super
    @block_config = {
      :filters => {},
      :order => []
    }
    @original_values = {}
  end
  attr_accessor :description, :name, :block_config, :original_values

  def blocknize!(visitor)
    raise "not equal order_key and original_values.keys" unless @original_values.keys.sort_by{|i| i.to_s} == @block_config[:order].sort_by{|i| i.to_s}
    self[:name] = self.name
    self.description ||= self.name
    self[:description] = self.description
    @block_config[:order].each do |key|
      value = @original_values[key].clone
      filters = @block_config[:filters][key]
      if visitor.class <= Test::Base
        filters.unshift(*visitor.filters).unshift(*(visitor.class.filters[key].to_a))
      end
      begin
        self[key] = apply_filters(value, filters, visitor)
      rescue => e
        raise ApplyFilterError.new("don't apply filter: #{e}\n#{e.backtrace.join("\n")}")
      end
      self.instance_eval "def #{key};self[%q{#{key}}.to_sym];end"
    end
    self
  end

  def append_block(name, value, filters)
    raise Test::Base::TestBaseError.new("already block data: #{name}") if @original_values.has_key?(name)
    @block_config[:filters][name] = filters
    @block_config[:order] << name
    @original_values[name] = value
  end

  def empty?
    @original_values.empty?
  end

  def inspect
    out = super
    "#<#{self.class}: #{out}\n original_values:#{@original_values.inspect}>"
  end

  private
  def apply_filters(value, filters, visitor)
    filters = fix_filter filters

    filters.each do |filter|
      if filter.class <= Proc
        value = filter.call value
      elsif filter.match(/\A(\.)?(.+)\Z/) # call from receiver
        if $1 == '.'
          method, args = str2method_args($2)
          if value.respond_to? method
            args = visitor.instance_eval "[#{args}]"
            value = value.__send__(method, *args)
          else
            raise filter
          end
        else
          if visitor.respond_to?(filter, true)
            case filter
            when 'eval', 'eval_stdout', 'eval_stderr', 'eval_all', 'erb'
              method = filter
              args = [visitor.respond_to?(:base_binding) ? visitor.base_binding : visitor.__send__(:binding)]
            else
              method, args = str2method_args(filter)
            end
            args ||= []
            args.unshift value
            value = visitor.__send__(method, *args)
          else
            raise filter
          end
        end
      end
    end
    value
  end

  def str2method_args(str)
    if m = str.match(/([^(].*)\((.*)\)/)
      if m[2].empty?
        [m[1], nil]
      else
        m[1..2]
      end
    else
      [str, nil]
    end
  end

  def receiver_call_method(method, visitor)
  end

  def fix_filter(filters)
    remove_filters = []
    filters = filters.delete_if do |e|
      if e.class <= String && e.match(/\A-(.+)\Z/)
        remove_filters << $1
        true
      end
    end
    filters - remove_filters
  end
end
