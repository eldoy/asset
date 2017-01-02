module Asset

  # # # # # #
  # Asset packer, middleware and helpers
  # @homepage: https://github.com/fugroup/asset
  # @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
  # @license:  MIT, contributions are welcome.
  # # # # # #

  class << self; attr_accessor :mode, :path, :cache, :manifest, :debug; end

  # Default is production
  @mode = ENV['RACK_ENV'] || MODE rescue 'development'
  @path = APP_ASSETS rescue File.join(Dir.pwd, 'app', 'assets')
  @cache = File.join(Dir.pwd, 'tmp')
  @debug = true

end

require_relative 'assets/util'
require_relative 'assets/item'

# Load the manifest
::Asset.manifest = ::Asset::Util.load_manifest


require_relative 'assets/helpers'
require_relative 'assets/router'
