# Chaussettes

Chaussettes is a wrapper around the command-line `sox` utility. It enables you
to manipulate audio by programmatically constructing a sox operation, including
multiple effect chains and various supported input and output streams.


## Installation

Simply gem install it.

    $ gem install chaussettes

It has no other dependencies, although it won't work
very well if you don't also install `sox`, which you can grab here: http://sox.sourceforge.net/.


## Usage

To find out information about an existing clip, you can use the
`Chaussettes::Info` class:

```ruby
require 'chaussettes'

info = Chaussettes::Info.new('hello.mp3')
p info.duration # 192.3 (seconds)
```

To programmatically construct a sox command-line, use the `Chaussettes::Clip`
class:

```ruby
require 'chaussettes'

clip = Chaussettes::Clip.new do |c|
  c.mix
  c.in 'music-track.mp3'
  c.in 'narration.wav'
  c.out 'soundtrack.wav'
end

clip.run
# sox --combine mix music-track.mp3 narration.wav soundtrack.wav
```

Each input and output can also accept options, which ought to be chained onto
the corresponding input:

```ruby
clip = Chaussettes::Clip.new do |c|
  c.mix
  c.in('music-track.mp3').volume(0.5)
  c.in 'narration.wav'
  c.out('soundtrack.wav').bits(16).rate(44_100).channels(2)
end

clip.run
# sox --combine mix \
#     --volume 0.5 music-track.mp3 \
#     narration.wav \
#     --bits 16 --rate 44100 --channels 2 soundtrack.wav
```

Furthermore, you can also chain effects to the clip:

```ruby
clip = Chaussettes::Clip.new do |c|
  c.mix
  c.in 'music-track.mp3'
  c.in 'narration.wav'
  c.out 'soundtrack.wav'
  c.chain.trim(0, 10).pad(1.5)
end
# sox --combine mix \
#     music-track.mp3 narration.wav soundtrack.wav \
#     trim 0 10 pad 1.5
```
_(Note that not all effects supported by sox are implemented by Chaussettes...yet)_

And multiple effect chains may be applied, for potentially complex effects:

```ruby
clip = Chaussettes::Clip.new do |c|
  c.mix
  c.in 'music-track.mp3'
  c.in 'narration.wav'
  c.out 'soundtrack.wav'
  c.chain.trim(0, 10).pad(1.5)
  c.chain.newfile
  c.chain.restart
end
# sox --combine mix \
#     music-track.mp3 narration.wav soundtrack.wav \
#     trim 0 10 pad 1.5 : newfile : restart
```

Inputs may be other clip instances, too:

```ruby
music = Chaussettes::Clip.new do |c|
  c.in 'music-track.mp3'
  c.out(device: :stdout).type(:wav)
  c.chain.fade(0, 10, 0.5)
end

clip = Chaussettes::Clip.new do |c|
  c.mix
  c.in(music).volume(0.5).type(:wav)
  c.in 'narration.wav'
  c.out 'soundtrack.wav'
end
# sox --combine mix \
#     --volume 0.5 --type wav "|sox music-track.mp3 --type wav - fade 0 10 0.5" \
#     narration.wav soundtrack.wav
```

## Author

Jamis Buck <jamis@jamisbuck.org>
