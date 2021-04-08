#!/usr/bin/env ruby

require 'json'
require_relative 'csv_to_lif'
require_relative 'lif_to_csv'
require_relative 'layers/android'

CONFIG = JSON.parse(File.read("./config.json"))

def generate_sheets(layer, directory)
  puts "Using layer type #{layer} and directory #{directory}"

  output_codes = get_gtranslate_codes_from_config()
  lifs = layer.get_sheet_generation_data(directory)

  puts "Desired language codes #{output_codes}"
  forward_converter = LifToCsvConverter.new(output_codes, lifs)
  forward_converter.generate()
  puts "generated CSV!"
end

private

def get_gtranslate_codes_from_config
  output_codes = []

  CONFIG["locales"].each do |item| 
    if item.is_a?(Hash)
      # fr-CA
      output_codes << "#{item["lang"]}-#{item["region"]}"
    else 
      # fr
      output_codes << item
    end
  end

  return output_codes
end

case ARGV[0]
when "-generate-android"
  android_directory = CONFIG["layers"]["android"]["path"]
  generate_sheets(AndroidStringsLayer.new(), android_directory)
else
  puts "unknown first argument :("
end
