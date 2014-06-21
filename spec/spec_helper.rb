$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'

gem 'minitest' # ensure we are using the gem version
require 'minitest/spec'
require 'minitest/autorun'

require 'proxifier'
