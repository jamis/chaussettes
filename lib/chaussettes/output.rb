require 'chaussettes/common_options'

module Chaussettes

  # Represents the output of an operation
  class Output
    include CommonOptions

    def initialize(dest = nil, device: nil)
      @dest = _translate_dest(dest) ||
              _translate_device(device) ||
              raise(ArgumentError, 'unsupported dest/device')

      @arguments = []
    end

    def _translate_dest(dest)
      dest ? dest.to_s : nil
    end

    def _translate_device(device)
      if device == :pipe
        '--sox-pipe'
      elsif device == :default
        '--default-device'
      elsif device.nil? || device == :null
        '--null'
      elsif device == :stdout
        '-'
      end
    end

    def commands
      [ *@arguments, @dest ]
    end

    def add_comment(text)
      @arguments << '--add-comment' << text
      self
    end

    def comment(text)
      @arguments << '--comment' << text
      self
    end

    def compression(factor)
      @arguments << '--compression' << factor
      self
    end
  end

end
