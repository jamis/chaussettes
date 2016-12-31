require 'chaussettes/input'
require 'chaussettes/output'
require 'chaussettes/effect_chain'
require 'chaussettes/tool'

module Chaussettes

  # encapsulates an invocation of sox
  class Clip
    def initialize
      @combine = nil
      @globals = []
      @inputs = []
      @output = nil
      @effect_chains = []

      yield self if block_given?
    end

    def command
      raise 'a clip requires at least one input' if @inputs.empty?
      raise 'a clip requires an output' if @output.nil?
      Tool.new('sox').tap { |sox| _build_command(sox) }
    end

    def run
      system(command.to_s)
    end

    def _build_command(sox)
      sox << '--combine' << @combine if @combine
      _append_globals sox
      _append_inputs sox
      _append_output sox
      _append_effects sox
    end

    def _append_globals(sox)
      @globals.each { |global| sox << global }
    end

    def _append_inputs(sox)
      @inputs.each { |input| sox.concat(input.commands) }
    end

    def _append_output(sox)
      sox.concat(@output.commands)
    end

    def _append_effects(sox)
      @effect_chains.each.with_index do |chain, idx|
        sox << ':' if idx > 0
        sox.concat(chain.commands)
      end
    end

    def combine(method)
      @combine = method
      self
    end

    def guard
      @globals << '--guard'
      self
    end

    def merge
      @combine = :merge
      self
    end

    def mix
      @combine = :mix
      self
    end

    def multiply
      @combine = :multiply
      self
    end

    def repeatable
      @globals << '-R'
      self
    end

    def verbose(level)
      @globals << "-V#{level}"
      self
    end

    def in(source = nil, device: nil)
      Input.new(source, device: device).tap do |input|
        @inputs << input
      end
    end

    def out(dest = nil, device: nil)
      @output = Output.new(dest, device: device)
    end

    def chain
      EffectChain.new.tap do |chain|
        @effect_chains << chain
      end
    end
  end

end
