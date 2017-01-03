module Asset
  class Item

    attr_accessor :path, :type, :key, :modified, :compress, :bundle, :name

    def initialize(*args)
      @path, @type, @key, @modified, @compress, @bundle = args
      @name = @path.rpartition('.')[0]
    end

    def file?
      @path !~ /^application\.(js|css)$/
    end

    def files(keyed = true)
      if file? or (keyed and ::Asset.mode == 'production')
        [keyed ? file : path]
      else
        ::Asset.manifest.select{|i| i.type == @type and i.file?}.map{|i| keyed ? i.file : i.path}
      end
    end

    def file
      return @path if ::Asset.mode == 'development'
      %{#{file? ? @name : 'application'}-#{@key}.#{@type}}
    end

    def content(cache = (::Asset.mode = 'production'))
      return joined unless cache

      File.read(File.join(::Asset.cache, %{#{@key}.#{@type}})).tap{|f| return f if f} rescue nil

      # Compress the files
      compressed.tap{|r| write_cache(r)}
    end

    # Store in cache
    def write_cache(r)
      File.open(File.join(::Asset.cache, %{#{@key}.#{@type}}), 'w') do |f|
        puts "Cached!: #{key}" if ::Asset.debug
        f.write(r)
      end
    end

    # Compressed joined files
    def compressed
      case @type
      when 'css'
        Tilt.new('scss', :style => :compressed){ joined }.render rescue joined
      when 'js'
        Uglifier.compile(joined, {}) rescue joined
      end
    end

    # All files joined
    def joined
      @joined ||= files(false).map{|f| File.read(File.join(::Asset.path, @type, f))}.join.tap{|r| puts "Joined: #{r.inspect}" if ::Asset.debug}
    end

    # Print data
    def print
      [:path, :type, :key, :name, :modified, :files, :content].each{|r| puts "#{r.upcase}: #{send(r).inspect}"}
    end

  end
end
