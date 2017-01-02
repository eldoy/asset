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

      # Path looks like app.js or similar
      path = name.is_a?(Hash) ? name.keys[0] : name

      # Get the modified time of the asset
      modified = File.mtime(File.join(::Asset.path, k, path)).utc

      # Record max to know the latest change
      max = modified if modified > max
      puts "NAME: #{name.inspect}"
      {
        path => {
          'key' => Digest::MD5.hexdigest(%{#{path}#{modified.to_i}}),
          'compress' => (name.is_a?(Hash) ? name['compress'] : true),
          'bundle' => (name.is_a?(Hash) ? name['bundle'] : true)
        }
      }
    end

    # Insert the max timestamp for use with bundle
    q[:application] = {:key => Digest::MD5.hexdigest(%{application#{max.to_i}})}
    puts q.inspect
    q
  end
end

require_relative 'assets/store'
require_relative 'assets/helpers'
require_relative 'assets/router'

