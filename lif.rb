#!/usr/bin/env ruby

# Language Intermediate Format
# Going into GSheets -> All LIFs are "en"
# Coming from GSheets -> LIFs are the translated languages, including the original "en" one

class LanguageIntermediateFormat
  attr_accessor :key, :value
  attr_accessor :language_code
  attr_accessor :locale, :region

  # TODO language_code is actually the "locale"
  def initialize(key, value, language_code)
    @key = key
    @value = value
    @language_code = language_code

    # Parse the language code
    if @language_code.include?("-")
      # en-US
      @locale, @region = @language_code.match(/(\w{2})-(\w{2})/).captures
    else 
      @locale = @language_code
      @region = nil
    end
  end

  # Turn \n into something nice
  def do_forwards_sanitization
    @value = @value.gsub("\\n", " 🎮 ")
  end

  # Turn something nice into \n
  def do_backwards_sanitization
    # Get rid of any errant spaces surrouding the delimiter
    @value = @value.gsub(/[ ]+🎮[ ]+/, "\\n")
  end

  def has_region?
    return !@region.nil?
  end

  def to_s
    "#{language_code} \t#{key}\t\t \"#{value}\""
  end
end

# lif1 = LanguageIntermediateFormat.new("key1", "hello world", "en")
# lif2 = LanguageIntermediateFormat.new("key1", "hello world", "en-US")

# puts lif1.locale, lif1.region, lif1.has_region?
# puts lif2.locale, lif2.region, lif2.has_region?
