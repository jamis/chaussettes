module Chaussettes
  module Effect

    # Represents a volume effect
    class Vol
      attr_reader :commands

      def initialize(gain, type: nil, limitergain: nil)
        @commands = [ 'vol' ]
        @commands << gain
        @commands << type if type
        @commands << limitergain if type && limitergain
        @commands.freeze
      end
    end

  end
end
