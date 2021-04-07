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
end
