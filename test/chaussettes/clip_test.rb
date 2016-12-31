require 'minitest/autorun'
require 'chaussettes/clip'

class ClipTest < Minitest::Test
  def setup
    @clip = Chaussettes::Clip.new
  end

  def test_merge_becomes_combine_option
    @clip.merge
    @clip.in
    @clip.out

    assert_equal 'sox --combine merge --null --null', @clip.command.to_s
  end

  def test_mix_becomes_combine_option
    @clip.mix
    @clip.in
    @clip.out

    assert_equal 'sox --combine mix --null --null', @clip.command.to_s
  end

  def test_multiply_becomes_combine_option
    @clip.multiply
    @clip.in
    @clip.out

    assert_equal 'sox --combine multiply --null --null', @clip.command.to_s
  end

  def test_combine_option
    @clip.in
    @clip.out
    @clip.combine :concatenate

    assert_equal 'sox --combine concatenate --null --null', @clip.command.to_s
  end

  def test_global_options
    @clip.guard.repeatable.verbose(2)
    @clip.in
    @clip.out

    assert_equal 'sox --guard -R -V2 --null --null', @clip.command.to_s
  end

  def test_multiple_inputs_are_rendered
    @clip.in('file1.wav')
    @clip.in('file2.wav')
    @clip.out
    assert_equal 'sox file1.wav file2.wav --null', @clip.command.to_s
  end

  def test_output_is_rendered
    @clip.in
    @clip.out('out.wav')
    assert_equal 'sox --null out.wav', @clip.command.to_s
  end

  def test_chain_adds_effect_chain
    @clip.in
    @clip.out
    @clip.chain.trim(0, 10).pad(1.5)
    assert_equal 'sox --null --null trim 0 10 pad 1.5', @clip.command.to_s
  end

  def test_multiply_effect_chains
    @clip.in
    @clip.out
    @clip.chain.trim(0, 10).pad(1.5)
    @clip.chain.newfile
    @clip.chain.restart
    assert_equal 'sox --null --null trim 0 10 pad 1.5 : newfile : restart',
                 @clip.command.to_s
  end
end
