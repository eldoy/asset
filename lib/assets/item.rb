module Asset
  class Item

    attr_accessor :path, :type, :key, :modified, :compress, :bundle, :name

    def initialize(*args)
      @path, @type, @key, @modified, @compress, @bundle = args
      @name = @path.split('.')[0]
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
      if cache
        result = File.read(File.join(::Asset.cache, %{#{@key}.#{@type}})) rescue nil

        # Return from cache if found
        return result if result

        # Read all the files and join them
        joined = files(false).map do |f|
          File.read(File.join(::Asset.path, @type, f))
        end.join

        puts "Joined: #{joined.inspect}"

        # Compress the files
        compressed = case @type
        when 'css'
          Tilt.new('scss', :style => :compressed){ joined }.render rescue joined
        when 'js'
          Uglifier.compile(joined, {}) rescue joined
        end

        # Store in cache
        File.open(File.join(::Asset.cache, %{#{@key}.#{@type}}), 'w') do |f|
          puts "Cached!: #{key}"
          f.write(compressed)
        end
        compressed
      else
        # Read all the files and join them
        joined = files(false).map do |f|
          File.read(File.join(::Asset.path, @type, f))
        end.join
      end
    end

    # Print data
    def print
      puts "PATH: #{@path}"
      puts "TYPE: #{@type}"
      puts "KEY: #{@key}"
      puts "NAME: #{@name}"
      puts "MOD: #{@modified}"
      puts "FILES: #{files.inspect}"
      puts "CONTENT: #{content}"
    end

  end
end
