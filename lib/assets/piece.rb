# Represents an asset

module Asset

  class Piece

    attr_reader :key, :asset_path, :md5, :compress

    # Options: compress [true / false (default)], md5
    def initialize(key, options = {})
      @compress = options[:compress] || false
      @key = key
      @type = @key.split('.')[-1]
      @path = File.join(APP_ASSETS, @type, @key)

      # Set up md5 cache checksum
      @md5 = options[:md5] || ::Asset::Util.digest(@path)

      # If we have a md5, we can cache it
      if @md5
        @cache_key = @key.gsub(/(\.[^.]+)$/){|ext| "-#{@md5}#{ext}" }
        @asset_path = File.join('/', 'assets', (@compress ? @cache_key : @key))
      end
    end

    # Cache path
    def cache_path
      @cache_path ||= "/tmp/#{@cache_key.gsub('/', '-')}"
    end

    # Get the content of the file
    def content
      @content ||= (@compress ? compressed_content : raw_content)
    end

    # Get compressed content
    def compressed_content
      @compressed_content ||= (read_cache rescue write_cache)
    end

    # Get raw content
    def raw_content
      @raw_content ||= (File.read(@path) rescue "")
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

    # Get the modified time of the file
    def modified
      @modified ||= (File.mtime(@path).to_i rescue 0)
    end

  end
end
