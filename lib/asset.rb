require 'rack'
require 'yaml'
require 'uglifier'
require 'tilt'

# Asset packer, middleware and helpers
# @homepage: https://github.com/fugroup/asset
# @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
# @license:  MIT, contributions are welcome.
module Asset
  class << self; attr_accessor :mode, :path, :cache, :favicon, :robots, :manifest, :debug; end

  # Default is production
  @mode = ENV['RACK_ENV'] || 'development'
  @path = File.join(Dir.pwd, 'app', 'assets')
  @cache = File.join(Dir.pwd, 'tmp')
  @debug = false
end

require_relative 'assets/util'
require_relative 'assets/item'

# Load the manifest
::Asset.manifest = ::Asset::Util.load_manifest

require_relative 'assets/helpers'
require_relative 'assets/router'
