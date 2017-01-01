require 'chaussettes'

Chaussettes::Clip.new do |clip|
  clip.show_progress false
  clip.in(device: nil)

  notes = %w(C3 E3 G3 C4)
  20.times do
    clip.chain.synth(0.2, :pluck) do |t|
      t.start_tone notes.sample, bias: 0, shift: rand(100), p1: 2
    end.synth(0.2, :pluck) do |t|
      t.combine :mix
      t.start_tone notes.sample, bias: 0, shift: rand(100), p1: 2
    end
  end

  # show the command that will be run
  puts clip.command('play')

  # play it!
  clip.play
end
