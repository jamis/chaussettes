require 'chaussettes/effect/fade'
require 'chaussettes/effect/gain'

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

    def trim(*positions)
      if positions.empty?
        raise ArgumentError, 'you must specify at least one position for trim'
      end

      @commands << 'trim'
      @commands.concat(positions)
      self
    end
  end

end
