require 'yaml'

module Asset

  # Represents a collection of assets

  class Pack

    attr_reader :assets, :compress, :manifest

    def initialize(key, options = {})
      puts "PACKING: #{key} ~> #{options.inspect}"
      @compress = options[:compress] || false
      @key = key
      @type = @key.split('.')[-1]

      # Read assets from pack
      @assets = []

      # Load manifest
      begin
        @manifest = YAML.load_file(File.join(APP_ASSETS, 'manifest.yml'))
      rescue
        puts "No manifest.yml file found at #{APP_ASSETS}"
        raise
      end

      @manifest[@type].each do |path|
        a = ::Asset::Piece.new(path, :compress => @compress)
        @assets << a if a.md5
      end
    end

    # Return the pack's asset path
    def asset_path
      @asset_path ||= (@compress ? pack_path : asset_list)
    end

    # MD5'ed path of the pack
    def pack_path
      @pack_path ||= "/assets/#{cache_key}"
    end

    # Cache key
    def cache_key
      @cache_key ||= @key.gsub(/(\.[^.]+)$/){|ext| "-#{md5}#{ext}" }
    end

    # Cache path
    def cache_path
      @cache_path ||= "/tmp/#{cache_key}"
    end

    # List of asset paths
    def asset_list
      @asset_paths ||= @assets.map{|a| "/assets/#{a.key}" }
    end

    # Calculate the whole pack's md5
    def md5
      @md5 ||= Digest::MD5.hexdigest(@assets.map(&:md5).join)
    end

    # Get the content of the pack
    def content
      @content ||= (@compress ? compressed_content : raw_content)
    end

    # Get compressed content
    def compressed_content
      @compressed_content ||= (read_cache rescue write_cache)
    end

    # Read cache
    def read_cache
      @read_cache ||= File.read(cache_path)
    end

    # Write cache
    def write_cache
      return @write_cache if @write_cache

      # Compress
      compressed = ::Asset::Util.send("#{@type}_compress", raw_content)

      File.open(cache_path, 'w'){|f| f.write(compressed)}
      @write_cache = compressed
    end

    # Get raw content
    def raw_content
      @raw_content ||= @assets.map(&:content).join
    end

    # Get the modified time of the pack
    def modified
      @modified ||= Time.at(@assets.map{|a| a.modified}.compact.max)
    end

  end
end
