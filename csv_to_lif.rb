#!/usr/bin/env ruby

require 'csv'
require 'fileutils'
require_relative 'lif'

OUTPUT_DIRECTORY = "translated_sheets"
BAD_VALUE = "#VALUE!"

class CsvToLifConverter
  # Returns a list of LIFs
  def read_input_sheets
    # TODO read all files in this directory 
    table = CSV.parse(File.read("#{OUTPUT_DIRECTORY}/output_sheet_1.csv"), headers: false)
    lifs = []

    # [row, column]
    key_row = 1

    # Traverse the CSV looking for valid values for keys
    while !table[key_row][0].nil? do
      lif_key = table[key_row][0]

      # Get all the translations on this row
      table[key_row].drop(1).each_with_index do |item, item_col|
        lif_value = item
        lif_code = table[0][item_col + 1]
        if lif_code.nil?
          break
        end
        lifs << LanguageIntermediateFormat.new(lif_key, lif_value, lif_code)
      end

      key_row += 1
    end

    return lifs
  end
end

# backward_converter = CsvToLifConverter.new()
# puts backward_converter.read_input_sheets()
