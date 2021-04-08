#!/usr/bin/env ruby

# Language Intermediate Format
# Going into GSheets -> All LIFs are "en"
# Coming from GSheets -> LIFs are the translated languages, including the original "en" one

class LanguageIntermediateFormat
  attr_accessor :key, :value
  attr_accessor :language_code

  def initialize(key, value, language_code)
    @key = key
    @value = value
    @language_code = language_code
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

  def to_s
    "#{language_code} #{key} \"#{value}\""
  end
end
