require 'shellwords'

module Chaussettes

  # a generic wrapper for sox audio toolchain
  class Tool
    def initialize(command)
      @command = command
      @arguments = []
    end

    def <<(arg)
      @arguments << arg
      self
    end

    def concat(args)
      @arguments.concat(args)
      self
    end

    def to_s
      Shellwords.join([ @command, *@arguments ])
    end
  end

end
