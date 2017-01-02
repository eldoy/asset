module Asset

  # # # # # #
  # Asset packer, middleware and helpers
  # @homepage: https://github.com/fugroup/asset
  # @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
  # @license:  MIT, contributions are welcome.
  # # # # # #

  class << self; attr_accessor :mode, :path, :manifest; end

  # Default is production
  @mode = ENV['RACK_ENV'] || MODE rescue 'development'
  @path = APP_ASSETS rescue File.join(Dir.pwd, 'app', 'assets')

  # Load the manifest
  max = Time.new(1979).utc
  @manifest = YAML.load_file(File.join(::Asset.path, 'manifest.yml')).
  inject({}) do |q, (k, v)|
    q[k] = v.map do |name|

      # Depending on the options, the name can be a string or a Hash
      h = name.is_a?(Hash)

      # Path looks like app.js or similar
      path = h ? name.keys[0] : name

      # Get the modified time of the asset
      modified = File.mtime(File.join(::Asset.path, k, path)).utc

      # Record max to know the latest change
      max = modified if modified > max

      # Key: used for caching, based on the last modified time stamp
      # Compress: This path should be compiled or not
      # Bundle: This path should be included in the application bundle
      {
        path => {
          'key' => Digest::MD5.hexdigest(%{#{path}#{modified.to_i}}),
          'compress' => (h ? name['compress'] : true),
          'bundle' => (h ? name['bundle'] : true)
        }
      }
    end

    # Insert the max timestamp for use with bundle
    q['application'] = {'key' => Digest::MD5.hexdigest(%{application#{max.to_i}})}
    q
  end
end

require_relative 'assets/store'
require_relative 'assets/helpers'
require_relative 'assets/router'

