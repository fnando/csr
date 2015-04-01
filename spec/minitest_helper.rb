require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'csr'
require 'minitest/autorun'
require 'minitest/rg'
require 'securerandom'
