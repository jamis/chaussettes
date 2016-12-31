require 'minitest/autorun'
require 'chaussettes/tool'

class ToolTest < Minitest::Test
  def setup
    @tool = Chaussettes::Tool.new('command')
  end

  def test_empty_arguments_should_render_only_the_command
    assert_equal 'command', @tool.to_s
  end

  def test_appended_arguments_should_be_rendered
    @tool << '-flag' << 'value'
    assert_equal 'command -flag value', @tool.to_s
  end

  def test_concatted_arguments_should_be_rendered
    @tool.concat [ '-flag', 'value' ]
    assert_equal 'command -flag value', @tool.to_s
  end

  def test_special_chars_should_be_escaped
    @tool << '-flag' << 'two words' << 'angry!'
    assert_equal 'command -flag two\ words angry\!', @tool.to_s
  end
end
