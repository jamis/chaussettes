require 'chaussettes/common_options'

module Chaussettes

  # Represents an input to an operation
  class Input
    include CommonOptions

    def initialize(source = nil, device: nil)
      @source = _translate_source(source) ||
                _translate_device(device) ||
                raise(ArgumentError, 'unsupported source')

      @arguments = []
    end

    def _translate_source(source)
      if source.is_a?(String)
        source
      elsif source.respond_to?(:command)
        "|#{source.command}"
      end
    end

    def _translate_device(device)
      if device == :default
        '--default-device'
      elsif device == :stdin
        '-'
      elsif device.nil? || device == :null
        '--null'
      end
    end

    def commands
      [ *@arguments, @source ]
    end

    def ignore_length
      @arguments << '--ignore-length'
      self
    end

    def volume(factor)
      @arguments << '--volume' << factor
      self
    end
  end

end
