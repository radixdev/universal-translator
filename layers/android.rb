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

  def apply_translations(directory, lifs)
    # Group by the language code
    code_mapping = {}
    lifs.each do |item| 
      k = item.language_code
      code_mapping[k] ||= []
      code_mapping[k] << item
    end

    # Get the strings file to edit
    code_mapping.each do |language_code, lifs_by_code|
      language = lifs_by_code[0].locale
      region = lifs_by_code[0].region
      strings_file = File.join(directory, get_strings_relative_path_from_locale(language, region))
      puts strings_file
      puts lifs_by_code

      if File.file?(strings_file)
        puts "file already exists"
      else
        puts "creating new strings file #{strings_file}"
      end
    end
  end

  private

  def get_strings_relative_path_from_locale(language, region)
    if !region.nil?
      # fr-CA
      # values-fr-rCA/strings.xml
      return "values-#{language}-r#{region}/strings.xml"
    else 
      # fr
      # values-fr/strings.xml
      return "values-#{language}/strings.xml"
    end
  end
end
