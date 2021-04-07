#!/usr/bin/env ruby

require_relative 'layers/android_strings'
require_relative 'csv_to_lif'
require_relative 'lif_to_csv'

droid = AndroidStringsLayer.new
droid.get_lif("test")
