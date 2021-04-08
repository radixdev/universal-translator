#!/usr/bin/env ruby

class BaseLayer
  # @param [String] Directory of our source material
  # @return [Array] the generated LIF array
  def get_generation_data(directory)
    raise 'not implemented'
  end

  # @param [Array] Array of the translated LIFs to apply
  def apply_translations(lifs)
    raise 'not implemented'
  end
end
