require 'chaussettes/effect/fade'
require 'chaussettes/effect/gain'
require 'chaussettes/effect/synth'
require 'chaussettes/effect/vol'

module Chaussettes

  # A chain of effects to apply
  class EffectChain
    attr_reader :commands

    def initialize
      @commands = []
    end

    def fade(in_len, stop_at = nil, out_len = nil, type: nil)
      effect = Effect::Fade.new(in_len, stop_at, out_len, type: type)
      @commands.concat(effect.commands)
      self
    end

    def gain(db, *opts)
      effect = Effect::Gain.new(db, *opts)
      @commands.concat(effect.commands)
      self
    end

    def newfile
      @commands << 'newfile'
      self
    end

    def pad(length, position = nil)
      length = "#{length}@#{position}" if position
      @commands << 'pad' << length
      self
    end

    def restart
      @commands << 'restart'
      self
    end

    def synth(length = nil, type = nil, &block)
      effect = Effect::Synth.new(length, type, &block)
      @commands.concat(effect.commands)
      self
    end

    def trim(*positions)
      if positions.empty?
        raise ArgumentError, 'you must specify at least one position for trim'
      end

      @commands << 'trim'
      @commands.concat(positions)
      self
    end

    def vol(gain, type: nil, limitergain: nil)
      effect = Effect::Vol.new(gain, type: type, limitergain: limitergain)
      @commands.concat(effect.commands)
      self
    end
  end

end
