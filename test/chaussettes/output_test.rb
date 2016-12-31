require 'minitest/autorun'
require 'chaussettes/output'

class OutputTest < Minitest::Test
  def test_init_with_string_should_use_string_as_dest
    output = Chaussettes::Output.new('output.wav')
    assert_equal [ 'output.wav' ], output.commands
  end

  def test_init_with_no_arguments_should_use_null_output
    output = Chaussettes::Output.new
    assert_equal [ '--null' ], output.commands
  end

  def test_init_with_nil_device_should_use_null_output
    output = Chaussettes::Output.new(device: nil)
    assert_equal [ '--null' ], output.commands
  end

  def test_init_with_null_device_should_use_null_output
    output = Chaussettes::Output.new(device: :null)
    assert_equal [ '--null' ], output.commands
  end

  def test_init_with_stdout_device_should_use_dash_output
    output = Chaussettes::Output.new(device: :stdout)
    assert_equal [ '-' ], output.commands
  end

  def test_init_with_pipe_device_should_use_sox_pipe_output
    output = Chaussettes::Output.new(device: :pipe)
    assert_equal [ '--sox-pipe' ], output.commands
  end

  def test_init_with_default_device_should_use_default_device
    output = Chaussettes::Output.new(device: :default)
    assert_equal [ '--default-device' ], output.commands
  end

  def test_arguments_should_precede_output_dest
    output = Chaussettes::Output.new('hello.mp3').
             comment('cmt').add_comment('cmt2').compression(2)
    expect = [ '--comment', 'cmt', '--add-comment', 'cmt2', '--compression', 2,
               'hello.mp3' ]
    assert_equal expect, output.commands
  end

  def test_common_options_should_be_included
    output = Chaussettes::Output.new('hello.mp3').
             bits(8).channels(2).encoding('encoding').rate(44_100).type('mp3').
             endian('little').reverse_nibbles.reverse_bits

    expected = [
      '--bits', 8, '--channels', 2, '--encoding', 'encoding', '--rate', 44_100,
      '--type', 'mp3', '--endian', 'little', '--reverse-nibbles',
      '--reverse-bits', 'hello.mp3'
    ]

    assert_equal expected, output.commands
  end
end
