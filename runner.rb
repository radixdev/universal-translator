#!/usr/bin/env ruby

require_relative 'layers/android_strings'

droid = AndroidStringsLayer.new
droid.get_lif("test")
