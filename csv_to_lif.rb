#!/usr/bin/env ruby

require 'csv'
require 'fileutils'
require_relative 'lif'

OUTPUT_DIRECTORY = "translated_sheets"
BAD_VALUE = "#VALUE!"

class CsvToLifConverter
  # Returns a list of LIFs
  def read_translated_sheets(layer)
    # TODO read all files in this directory 
    table = CSV.parse(File.read("#{OUTPUT_DIRECTORY}/output_sheet_1.csv"), headers: false)
    lifs = []
    
    # [row, column]
    key_row = 1

    # Traverse the CSV looking for valid values for keys
    while (!table[key_row].nil? && !table[key_row][0].nil?) do
      lif_key = table[key_row][0]

      # Get all the translations on this row
      table[key_row].drop(1).each_with_index do |item, item_col|
        lif_code = table[0][item_col + 1]
        # No code means the columns past this point are invalid
        if lif_code.nil?
          break
        end
        if lif_code == "en" || item == BAD_VALUE
          next
        end
        lif = LanguageIntermediateFormat.new(lif_key, item, lif_code)
        layer.prepare_lif_for_writeback(lif)
        lifs << lif
      end

      key_row += 1
    end

    return lifs
  end
end

# backward_converter = CsvToLifConverter.new()
# puts backward_converter.read_translated_sheets()
