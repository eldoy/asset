require 'rack'
require 'yaml'

# Asset packer, middleware and helpers
# @homepage: https://github.com/fugroup/asset
# @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
# @license:  MIT, contributions are welcome.
module Asset
  autoload :Uglifier, 'uglifier'
  autoload :Sass, 'sass'

  class << self; attr_accessor :mode, :path, :cache, :favicon, :robots, :manifest, :bundle, :images, :listener, :debug; end

  # Default is development
  @mode = ENV['RACK_ENV'] || 'production'

  # Where your assets live
  @path = File.join(Dir.pwd, 'app', 'assets')

  # Where to write the cache, default to /tmp
  # Set to APP_ROOT: @cache = File.join(Dir.pwd, 'tmp')
  @cache = '/tmp'

  # Automatically bounce (404) for browser /favicon.ico requests
  @favicon = true

  # Send /robots.txt to a standard robots txt with reference to /sitemap.xml
  @robots = true

  # Reset the assets on change in development mode
  @listener = true

  # Debug option
  @debug = false
end

require_relative 'assets/util'
require_relative 'assets/item'

::Asset::Util.setup!

require_relative 'assets/helpers'
require_relative 'assets/filters'
require_relative 'assets/router'

# Run a listener to automatically reload the assets on change
if ::Asset.listener and ::Asset.mode == 'development'
  begin
    require 'listen'
    Listen.to(::Asset.path){|m, a, r| ::Asset::Util.setup!}.start if defined?(Listen)
  rescue LoadError
  end
end
