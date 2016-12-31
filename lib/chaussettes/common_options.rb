module Chaussettes

  # options that are common between input and output files
  module CommonOptions
    def bits(bits)
      @arguments << '--bits' << bits
      self
    end

    def channels(channels)
      @arguments << '--channels' << channels
      self
    end

    def encoding(encoding)
      @arguments << '--encoding' << encoding
      self
    end

    def rate(rate)
      @arguments << '--rate' << rate
      self
    end

    def type(type)
      @arguments << '--type' << type
      self
    end

    def endian(option)
      @arguments << '--endian' << option
      self
    end

    def reverse_nibbles
      @arguments << '--reverse-nibbles'
      self
    end

    def reverse_bits
      @arguments << '--reverse-bits'
      self
    end
  end

end
