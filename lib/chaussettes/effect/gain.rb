module Chaussettes
  module Effect

    # Represents a gain effect
    class Gain
      TYPE_MAP = {
        :e => 'e', 'e' => 'e', :equalize => 'e',
        :B => 'B', 'B' => 'B', :balance => 'B',
        :b => 'b', 'b' => 'b', :balance_protect => 'b',
        :r => 'r', 'r' => 'r', :reclaim_headroom => 'r',
        :n => 'n', 'n' => 'n', :normalize => 'n',
        :l => 'l', 'l' => 'l', :limiter => 'l',
        :h => 'h', 'h' => 'h', :headroom => 'h'
      }.freeze

      attr_reader :commands

      def initialize(db, *opts)
        @commands = [ 'gain' ]
        @commands.concat(opts.map { |opt| TYPE_MAP.fetch(opt) })
        @commands << db
        @commands.freeze
      end
    end

  end
end
