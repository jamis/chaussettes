# ruby ducking.rb track1 track2 output delay
#
# Mixes two tracks by reducing the volume of the first during the duration
# of the second. The second track begins after delay seconds. Saves the
# result as output.

require 'chaussettes'

track1 = ARGV[0] || abort("what's the first track?")
track2 = ARGV[1] || abort("what's the second track?")
delay  = ARGV[2] || abort("what's the delay in seconds?")
output = ARGV[3] || abort("what's the output filename?")

info1 = Chaussettes::Info.new(track1)
info2 = Chaussettes::Info.new(track2)
delay = delay.to_f

if info1.duration < info2.duration + delay
  abort 'first track is shorter than the second track!'
end

intro = Chaussettes::Clip.new do |clip|
  clip.in(track1)
  clip.out(device: :stdout).type(:wav)
  clip.chain.fade(0, delay + 0.2, 0.4, type: :linear)
end

middle = Chaussettes::Clip.new do |clip|
  clip.in(track1)
  clip.out(device: :stdout).type(:wav)
  clip.chain.
    trim(delay, info2.duration).
    vol(0.25).
    pad(delay)
end

last = Chaussettes::Clip.new do |clip|
  clip.in(track1)
  clip.out(device: :stdout).type(:wav)
  clip.chain.
    trim(delay + info2.duration - 0.2).
    fade(0.4, type: :linear).
    pad(delay + info2.duration - 0.2)
end

overlay = Chaussettes::Clip.new do |clip|
  clip.in(track2)
  clip.out(device: :stdout).type(:wav)
  clip.chain.pad(delay)
end

Chaussettes::Clip.new do |clip|
  clip.mix

  clip.in(intro).type(:wav)
  clip.in(middle).type(:wav)
  clip.in(last).type(:wav)
  clip.in(overlay).type(:wav)

  clip.out(output)
  # ramp up the volume x4 to compensate for 4 clips being merged together
  clip.chain.vol 4

  clip.run
end
