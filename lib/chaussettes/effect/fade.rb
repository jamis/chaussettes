module Chaussettes
  module Effect

    # Represents a fade effect
    class Fade
      TYPE_MAP = {
        nil => nil,
        :h => 'h', 'h' => 'h', :half_sine => 'h',
        :l => 'l', 'l' => 'l', :log => 'l', :logarithmic => 'l',
        :p => 'p', 'p' => 'p', :parabola => 'p', :inverted_parabola => 'p',
        :q => 'q', 'q' => 'q', :quarter => 'q',
        :t => 't', 't' => 't', :linear => 't', :triangle => 't'
      }.freeze

      attr_reader :commands

      def initialize(in_len, stop_at = nil, out_len = nil, type: nil)
        real_type = TYPE_MAP.fetch(type)

        @commands = [ 'fade' ]
        @commands << real_type if real_type
        @commands << in_len
        @commands << stop_at if stop_at
        @commands << out_len if stop_at && out_len

        @commands.freeze
      end
    end

  end
end
