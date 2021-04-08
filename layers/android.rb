#!/usr/bin/env ruby

require 'nokogiri'
require_relative '../base_layer'
require_relative '../lif'

class AndroidStringsLayer < BaseLayer
  def get_generation_data(input_dir)
    # Get the "en" LIFs
    strings_en_file = File.join(input_dir, "values/strings.xml")
    doc = File.open(strings_en_file) { |f| Nokogiri::XML(f) }

    lifs = []
    doc.xpath("//string").each do |item| 
      if item["translatable"] == "false"
        next
      end

      lif = LanguageIntermediateFormat.new(item["name"], item.content, "en")
      lif.do_forwards_sanitization()
      lifs << lif
    end

    return lifs
  end
end
