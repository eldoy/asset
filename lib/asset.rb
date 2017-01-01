module Asset

  # # # # # #
  # Asset packer, middleware and helpers
  # @homepage: https://github.com/fugroup/asset
  # @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
  # @license:  MIT, contributions are welcome.
  # # # # # #

  class << self; attr_accessor :mode, :path; end

  # Default is production
  @mode = ENV['RACK_ENV'] || MODE rescue 'development'
  @path = APP_ASSETS rescue File.join(Dir.pwd, 'app', 'assets')
end

require_relative 'assets/store'
require_relative 'assets/helpers'
require_relative 'assets/router'

