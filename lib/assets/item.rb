module Asset
  class Item

    attr_accessor :path, :type, :key, :modified, :compress, :bundle, :name

    # Init
    def initialize(*args)
      @path, @type, @key, @modified, @compress, @bundle = args
      @name = @path.rpartition('.')[0]
    end

    # File? Not bundle?
    def file?
      @path !~ /^application\.(js|css)$/
    end

    # Get the files. Pass keyed = false to get the path instead of the file
    def files(keyed = true)
      if file? or (keyed and ::Asset.mode == 'production')
        [keyed ? file : path]
      else
        ::Asset.manifest.select{|i| i.type == @type and i.file?}.map{|i| keyed ? i.file : i.path}
      end
    end

    # Get the file, meaning the full path with key
    def file
      ::Asset.mode == 'development' ? @path : %{#{file? ? @name : 'application'}-#{@key}.#{@type}}
    end

    # Get the content. Pass cache = false to fetch from disk instead of the cache.
    def content(key = nil)
      key ? (@cached ||= cached) : (@joined ||= joined)
    end

    # The cached content
    def cached
      File.read(cache_path).tap{|f| return f if f} rescue nil

      # Compress the files
      compressed.tap{|r| write_cache(r)}
    end

    # Store in cache
    def write_cache(r)
      File.open(cache_path, 'w'){|f| f.write(r)}
    end

    # Cache path
    def cache_path
      @cache_path ||= File.join(::Asset.cache, %{#{@key}.#{@type}})
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
      @joined ||= files(false).map{|f| File.read(File.join(::Asset.path, @type, f))}.join
    end

    # Print data
    def print
      [:path, :type, :key, :name, :modified, :files, :content].map{|r| "#{r.upcase}: #{send(r).inspect}"}.join("\n")
    end

  end
end
