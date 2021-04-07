#!/usr/bin/env ruby

require 'csv'
require 'fileutils'
require_relative 'lif'

class LifToCsvConverter
  attr_accessor :output_codes
  attr_accessor :input_lifs

  def initialize(output_codes, input_lifs)
    @output_codes = output_codes
    @input_lifs = input_lifs
  end

  def generate
    data = CSV.generate do |csv|
      # Get our first row
      first_row = [:KEYS, :en] + output_codes
      csv << first_row

      # Now start adding our input lifs
      input_lifs.each { |item| 
        csv << [item.key, item.value]
      }
    end

    unless Dir.exist?("untranslated_sheets")
      FileUtils.mkdir("untranslated_sheets")
    end
    File.write("untranslated_sheets/input_sheet_1.csv", data)
  end
end

output_codes = ["fr", "es", "ja"]
lif1 = LanguageIntermediateFormat.new("key1", "hello world", "en")
lif2 = LanguageIntermediateFormat.new("key2", "banana stand", "en")

forward_converter = LifToCsvConverter.new(output_codes, [lif1, lif2])
forward_converter.generate()
