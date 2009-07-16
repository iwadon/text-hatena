require 'test/base/base'
require 'yaml'
require 'erb'
require 'stringio'

module Test::Base::Filters
  def eval(str, b = binding)
    Kernel::eval str, b
  end

  def eval_stdout(str, b = binding)
    old_stream = $stdout.dup
    sio = StringIO.new
    $stdout = sio
    Kernel::eval str, b
    sio.rewind
    res = sio.read
    sio.close
    res
  ensure
    $stdout = old_stream
  end


  def eval_stderr(str, b = binding)
    old_stream = $stderr.dup
    sio = StringIO.new
    $stderr = sio
    Kernel::eval str, b
    sio.rewind
    res = sio.read
    sio.close
    res
  ensure
    $stderr = old_stream
  end

  def eval_all(str, b = binding)
    old_stream = $stdout.dup
    old_stream_err = $stderr.dup
    sio = StringIO.new
    sioerr = StringIO.new
    $stdout = sio
    $stderr = sioerr
    begin
      res = Kernel::eval str, b
    rescue Exception => e
      res = e
    end

    sio.rewind
    sioerr.rewind

    sres = sio.read
    eres = sioerr.read
    sio.close
    sioerr.close
    [res, sres, eres]
  ensure
    $stdout = old_stream
    $stderr = old_stream_err
  end

  def erb(str, b = binding)
    ERB.new(str, nil, '-').result(b)
  end

  def yaml(str)
    YAML::load(str)
  end

end
