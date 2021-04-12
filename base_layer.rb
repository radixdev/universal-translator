#!/usr/bin/env ruby

class BaseLayer
  # @param [String] Directory of our source material
  # @return [Array] the generated LIF array
  def get_generation_data(directory)
    raise 'not implemented'
  end

  # @param [Array] Array of the translated LIFs to apply
  def apply_translations(directory, lifs)
    raise 'not implemented'
  end

  def prepare_lif_for_translation(lif)
    raise 'not implemented'
  end

  def prepare_lif_for_writeback(lif)
    raise 'not implemented'
  end

  # Reads the source directory and prints the "locales" portion
  # of the json based on the locales already existing there.
  # 
  # @param [String] Directory of our source material
  def read_existing_locales(directory)
    raise 'not implemented'
  end
end
