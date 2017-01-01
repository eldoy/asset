# Represents an asset

module Asset

  class Store
    class << self; attr_accessor :manifest; end
    @manifest = YAML.load_file(File.join(APP_ASSETS, 'manifest.yml'))

    attr_accessor :type, :name, :base, :md5, :key, :files

    def initialize(path, type = path.split('.')[-1])
      @type = type
      @name = path.split('/')[-1]
      @name =~ /(.*)-([a-f0-9]{1,32})\.(.*)/
      @name = @name.gsub("-#{@md5}", '') if (@md5 = $2)
      @base = $1 || @name.rpartition('.')[0]
      @key = "#{@base}#{@md5 ? "-#{@md5}" : ''}.#{@type}"
      @files = []

      if @base == 'application'
        self.class.manifest[@type].each do |p|
          @files << abs(p)
        end
      else
        @files << abs(@name)
      end

      # Remove nil
      @files.delete_if{|f| !File.file?(f)}
    end

    # The cached content
    def cached
      begin
        File.read(tmp(@key)) if @md5 and @files.any?
      rescue
        # No cache found, cache it
        compressed.tap do |c|
          File.open(tmp(@key), 'w'){|f| f.write(c)}
          puts "Cached!: #{@key}"
        end
      end
    end

    # The compressed content
    def compressed
      # Compress the file
      @compressed ||= case @type
      when 'css'
        Tilt.new('scss', :style => :compressed){ joined }.render rescue str
      when 'js'
        Uglifier.compile(joined, {}) rescue str
      end
    end

    # The joined content
    def joined
      @files.map{|f| File.read(f)}.join
    end

    # The content on disk
    def content
      File.read(@files[0]) rescue nil
    end

    # File absolute path, nil if it doesn't exist
    def abs(f)
      File.join(APP_ASSETS, @type, f)
    end

    # Find the cache path
    def tmp(f)
      File.join('tmp', f)
    end

    # Print data
    def print
      puts "TYPE: #{@type}"
      puts "NAME: #{@name}"
      puts "BASE: #{@base}"
      puts "MD5: #{@md5}"
      puts "KEY: #{@key}"
      puts "FILES: #{@files.inspect}"
      puts "CONTENT: #{@content}"
    end
  end
end
