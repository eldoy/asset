module Asset

  # # # # # #
  # Asset packer, middleware and helpers
  # @homepage: https://github.com/fugroup/asset
  # @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
  # @license:  MIT, contributions are welcome.
  # # # # # #

  class << self; attr_accessor :mode; end

  # Default is production
  @mode = ENV['RACK_ENV'] || MODE rescue 'development'
end

require_relative 'assets/store'
require_relative 'assets/helpers'
require_relative 'assets/router'

