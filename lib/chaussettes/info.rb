require 'chaussettes/tool'

module Chaussettes

  # encapsulates info about an audio file
  class Info
    def initialize(filename)
      command = Tool.new('soxi') << filename
      output = `#{command}`
      @data = _parse(output)
    end

    def _parse(output)
      output.lines.each.with_object({}) do |line, hash|
        next if line.strip.empty?
        key, value = line.split(/:/, 2)
        hash[key.strip] = value.strip
      end
    end

    def filename
      @_filename ||= @data['Input File']
    end

    def channels
      @_channels ||= @data['Channels'].to_i
    end

    def rate
      @_rate ||= @data['Sample Rate'].to_i
    end

    def bits
      @_bits ||= @data['Precision'].to_i
    end

    def duration
      @_duration ||= begin
        timespec = @data['Duration'].split(/ /).first
        h, m, s = timespec.split(/:/)

        h.to_i * 3600 +
          m.to_i * 60 +
          s.to_f
      end
    end

    def size
      @_size ||= @data['File Size']
    end

    def bit_rate
      @_bit_rate ||= @data['Bit Rate']
    end
  end

end
