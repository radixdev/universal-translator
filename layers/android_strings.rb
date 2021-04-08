#!/usr/bin/env ruby

require 'nokogiri'
require_relative '../base_layer'
require_relative '../lif'

class AndroidStringsLayer < BaseLayer
  def get_sheet_generation_data(input_dir)
    # Get the "en" LIFs
    strings_en_file = File.join(input_dir, "values/strings.xml")
    doc = File.open(strings_en_file) { |f| Nokogiri::XML(f) }

    lifs = []
    doc.xpath("//string").each do |item| 
      if item["translatable"] == "false"
        next
      end

      key = item["name"]
      value = item.content
      lifs << LanguageIntermediateFormat.new(key, value, "en")
    end

    return [], lifs
  end
end
