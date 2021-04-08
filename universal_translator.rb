#!/usr/bin/env ruby

require_relative 'csv_to_lif'
require_relative 'lif_to_csv'
require_relative 'layers/android_strings'

def generate_sheets(layer_type)
  directory = ARGV[1]

  # TODO do some switching on type here
  layer_type = AndroidStringsLayer.new
  output_codes, lifs = layer_type.get_sheet_generation_data(directory)

  puts output_codes
  puts lifs
  # forward_converter = LifToCsvConverter.new(output_codes, lifs)
  # forward_converter.generate()
end

case ARGV[0]
when "-generate-android"
  generate_sheets("android_strings")
else
  puts "unknown first argument :("
end
