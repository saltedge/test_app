# ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['PORT'] = "9009"
ENV['HOST'] = "0.0.0.0"

require 'bundler/setup'  if File.exist?(ENV['BUNDLE_GEMFILE'])

# require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
