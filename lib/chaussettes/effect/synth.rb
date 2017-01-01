module Chaussettes
  module Effect

    # Represents a synth effect
    class Synth
      attr_reader :commands

      def initialize(length = nil, type = nil)
        @length = length
        @type = type

        @just_intonation = nil
        @combine = nil
        @start_tone = nil
        @end_tone = nil
        @headroom = true

        yield self if block_given?

        _build_commands
      end

      def _build_commands
        @commands = [ 'synth' ]
        @commands << '-j' << @just_intonation if @just_intonation
        @commands << '-n' unless @headroom

        _append_start_params

        @commands << @type if @type
        @commands << @combine if @combine

        _append_tones

        @commands.freeze
      end

      def _append_start_params
        return unless @length
        @commands << @length
        _append_opts @start_opts
      end

      OPT_NAMES = %i(bias shift p1 p2 p3).freeze
      DEFAULTS = { bias: 0, shift: 0 }.freeze

      def _append_opts(opts)
        return unless opts && opts.any?

        OPT_NAMES.each do |opt|
          value = opts[opt] || DEFAULTS[opt]
          break unless value
          @commands << value
        end
      end

      def _append_tones
        return unless @start_tone

        tone = if @end_tone
                 "#{@start_tone}#{@sweep}#{@end_tone}"
               else
                 @start_tone
               end

        @commands << tone

        _append_opts @end_opts
      end

      def headroom(enabled)
        @headroom = enabled
        self
      end

      def just_intonation(semitones)
        @just_intonation = semitones
        self
      end

      def combine(method)
        @combine = method
        self
      end

      def length(len)
        @length = len
        self
      end

      def type(type)
        @type = type
        self
      end

      # options are:
      #   bias:
      #   shift:
      #   p1:
      #   p2:
      #   p3:
      def start_tone(start_tone, opts = {})
        @start_tone = start_tone
        @start_opts = opts
        self
      end

      # options are:
      #   bias:
      #   shift:
      #   p1:
      #   p2:
      #   p3:
      def end_tone(end_tone, sweep = :linear, opts = {})
        @end_tone = end_tone
        @sweep = SWEEPS.fetch(sweep, sweep)
        @end_opts = opts
        self
      end

      SWEEPS = {
        linear: ':',
        square: '+',
        exponential: '/', exp: '/',
        exp2: '-'
      }.freeze
    end

  end
end
