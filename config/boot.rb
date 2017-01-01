require 'bundler/setup'
Bundler.require(:default, :development)

MODE = ENV['RACK_ENV'] || 'development'

APP_ROOT = Dir.pwd
APP_VIEWS = File.join(APP_ROOT, 'app', 'views')
APP_ASSETS = File.join(APP_ROOT, 'app', 'assets')

require './app/middleware/print.rb'
require './lib/asset.rb'

