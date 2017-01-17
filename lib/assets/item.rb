module Asset
  class Item

    attr_accessor :path, :type, :key, :modified, :app, :name, :kpath

    # Init
    def initialize(*args)
      @path, @type, @key, @modified = args
      @app = !!(@path =~ /^bundle\.(js|css)$/)
      @name = @path.rpartition('.')[0]
      @kpath = "#{@name}-#{kext}"
    end

    # Get the files for this item
    def files
      (@app and !p?) ? bundle_files : [p? ? @kpath : @path]
    end

    # Get the full path
    def src
      File.join('/assets', @type, (p? ? @kpath : @path))
    end

    # Get the files for the bundle
    def bundle_files
      @bundle_files ||= ::Asset.manifest.select{|i| ::Asset.bundle[type].include?(i.path) and i.type == @type and !i.app}.map{|i| p? ? i.kpath : i.path}
    end

    # Get the content. Pass cache = false to fetch from disk instead of the cache.
    def content(key = nil)
      !key ? (@joined ||= joined) : (@cached ||= cached)
    end

    # The cached content
    def cached
      File.read(cache_path).tap{|f| return f if f} rescue nil
      compressed.tap{|r| write_cache(r)}
    end

    # Store in cache
    def write_cache(r)
      File.open(cache_path, 'w'){|f| f.write(r)}
    end

    # Cache path
    def cache_path
      @cache_path ||= File.join(::Asset.cache, kext)
    end

    # Key and extension
    def kext
      @kext ||= %{#{@key}.#{@type}}
    end

    # Compressed joined files
    def compressed
      @compressed ||= case @type
      when 'css'
        Tilt.new('scss', :style => :compressed){ joined }.render rescue joined
      when 'js'
        Uglifier.compile(joined, {}) rescue joined
      end
    end

    # All files joined
    def joined
      @joined ||= files.map{|f| File.read(File.join(::Asset.path, @type, f))}.join
    end

    # Production mode?
    def p?
      ::Asset.mode == 'production'
    end

    # Print data
    def print
      [:path, :type, :key, :name, :modified, :files, :content].map{|r| "#{r.upcase}: #{send(r).inspect}"}.join("\n")
    end

  end
end
