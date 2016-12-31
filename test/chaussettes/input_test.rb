require 'minitest/autorun'
require 'ostruct'
require 'chaussettes/input'

class InputTest < Minitest::Test
  def test_init_with_string_should_use_string_as_source
    input = Chaussettes::Input.new('input.wav')
    assert_equal [ 'input.wav' ], input.commands
  end

  def test_init_with_command_should_use_command_as_source
    command = OpenStruct.new(command: 'cmd -x -y -z')
    input = Chaussettes::Input.new(command)
    assert_equal [ '|cmd -x -y -z' ], input.commands
  end

  def test_init_with_no_arguments_should_use_null_input
    input = Chaussettes::Input.new
    assert_equal [ '--null' ], input.commands
  end

  def test_init_with_nil_device_should_use_null_input
    input = Chaussettes::Input.new(device: nil)
    assert_equal [ '--null' ], input.commands
  end

  def test_init_with_null_device_should_use_null_input
    input = Chaussettes::Input.new(device: :null)
    assert_equal [ '--null' ], input.commands
  end

  def test_init_with_stdin_device_should_use_dash_input
    input = Chaussettes::Input.new(device: :stdin)
    assert_equal [ '-' ], input.commands
  end

  def test_init_with_default_device_should_use_default_device
    input = Chaussettes::Input.new(device: :default)
    assert_equal [ '--default-device' ], input.commands
  end

  def test_arguments_should_precede_input_source
    input = Chaussettes::Input.new('hello.mp3').ignore_length.volume(0.5)
    expect = [ '--ignore-length', '--volume', 0.5, 'hello.mp3' ]
    assert_equal expect, input.commands
  end

  def test_common_options_should_be_included
    input = Chaussettes::Input.new('hello.mp3').
            bits(8).channels(2).encoding('encoding').rate(44_100).type('mp3').
            endian('little').reverse_nibbles.reverse_bits

    expected = [
      '--bits', 8, '--channels', 2, '--encoding', 'encoding', '--rate', 44_100,
      '--type', 'mp3', '--endian', 'little', '--reverse-nibbles',
      '--reverse-bits', 'hello.mp3'
    ]

    assert_equal expected, input.commands
  end
end
