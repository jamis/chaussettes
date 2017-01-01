require 'chaussettes'

RHYTHM = [ 2, 1, 1, 2, 1, 0.5, 0.5, 2, 1, 1, 2, 1, 0.5, 0.5, 2 ].freeze
BEAT = 0.25

Chaussettes::Clip.new do |clip|
  clip.show_progress(false)
  clip.in(device: nil)

  RHYTHM.each do |dur|
    chain = clip.chain
    chain.synth(BEAT * dur, :pluck) do |t|
      t.start_tone nil, p1: 0.1
    end
    chain.synth(BEAT * dur, :noise) do |t|
      t.combine :fmod
    end
  end

  puts clip.command('play')
  clip.play
end
