require 'rack'
require 'yaml'

# Asset packer, middleware and helpers
# @homepage: https://github.com/fugroup/asset
# @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
# @license:  MIT, contributions are welcome.
module Asset

  autoload :Uglifier, 'uglifier'
  autoload :Sass, 'sass'

  class << self; attr_accessor :mode, :path, :cache, :favicon, :robots, :manifest, :bundle, :images, :debug; end

  # Default is development
  @mode = ENV['RACK_ENV'] || 'development'

  # Where your assets live
  @path = File.join(Dir.pwd, 'app', 'assets')

  # Where to write the cache, default to APP_ROOT/tmp
  @cache = File.join(Dir.pwd, 'tmp')

  # Automatically bounce (404) for browser /favicon.ico requests
  @favicon = true

  # Send /robots.txt to a standard robots txt with reference to /sitemap.xml
  @robots = true

  # Debug option
  @debug = false
end

require_relative 'assets/util'
require_relative 'assets/item'

# Load the manifest
::Asset.manifest = ::Asset::Util.load_manifest

# Load the bundle
::Asset.bundle = YAML.load_file(File.join(::Asset.path, 'manifest.yml'))

# Load the images
::Asset.images = ::Asset::Util.load_images

require_relative 'assets/helpers'
require_relative 'assets/filters'
require_relative 'assets/router'
