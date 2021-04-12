#!/usr/bin/env ruby

require 'nokogiri'
require 'json'
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
      # lif.do_forwards_sanitization()
      prepare_lif_for_translation(lif)
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

      if File.file?(strings_file)
        puts "updating existing #{strings_file}"
        doc = File.open(strings_file) { |f| Nokogiri::XML(f) }
        update_xml_document(strings_file, lifs_by_code, doc)
      else
        puts "creating new strings file #{strings_file}"
        FileUtils.mkdir_p(File.expand_path("..", strings_file))
        doc = Nokogiri::XML('<?xml version="1.0" encoding="utf-8"?><resources></resources>')
        update_xml_document(strings_file, lifs_by_code, doc)
      end
    end
  end

  def prepare_lif_for_translation(lif)
    lif.value = lif.value.gsub("\\n", " 🎮 ")
    lif.value = lif.value.gsub("\\'", "'")
  end

  def prepare_lif_for_writeback(lif)
    # Get rid of any errant spaces surrouding the newline delimiter
    lif.value = lif.value.gsub(/[ ]+🎮[ ]+/, "\\n")
    lif.value = lif.value.gsub("'", "\\\\'")
  end

  def read_existing_locales(directory)
    # Get every directory that looks like a 
    # locale and has a "strings.xml" file in it

    locales = []
    Dir.foreach(directory) do |file|
      path = File.join(directory, file)
      if (file == '.' || file == '..' || file == '.DS_Store')
        next
      end
      if !File.directory?(path) || file.include?("dpi") || !file.include?("values-")
        next
      end

      match = file.match(/values-(\D{2})(-r(\D{2}))?/)
      if match.nil?
        next
      end

      language_code, _, region = match.captures
      if language_code.nil?
        puts "somehow got nil language code for #{file}"
        next
      end

      if region.nil?
        # just the language
        locales << language_code
      else
        locales << {"lang" => language_code, "region" => region}
      end
    end

    locales = locales.sort do |a, b|
      if a.is_a?(Hash)
        a_val = a["lang"] + a["region"]
      else 
        a_val = a
      end
      if b.is_a?(Hash)
        b_val = b["lang"] + b["region"]
      else 
        b_val = b
      end

      a_val <=> b_val
    end
    puts JSON.pretty_generate(locales)
  end

  private

  def update_xml_document(file, lifs, doc)
    resources = doc.at_css('resources')

    lifs.each do |item|
      new_string = Nokogiri::XML::Node.new("string", doc)
      new_string.content = item.value
      new_string["name"] = item.key

      # Get any existing node with the same key
      existing_key = doc.xpath("//string[@name=\"#{item.key}\"]").first
      if existing_key.nil?
        # Add our new key
        resources.add_child("\n  #{new_string.to_xml}")
      else 
        # Overwrite the original
        existing_key.replace(new_string)
      end
    end
    resources.add_child("\n")
    # Remove any extra newlines
    File.write(file, doc.to_s.gsub(/\n*\n/, "\n"))
  end

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
