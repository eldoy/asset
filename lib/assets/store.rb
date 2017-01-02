module Asset
  # # # # # # # # #
  # The Store class is responsible for compressing your assets if possible,
  # or serve the file directly.
  #
  # Use the helpers to display all files in your manifest.yml if you
  # are running development mode, in production it displays the compressed version.
  #

  class Store

    # The manifest is loaded from /app/assets/manifest.yml
    class << self; attr_accessor :manifest; end

    # Accessors
    attr_accessor :type, :path, :name, :md5, :key, :files

    # Init
    def initialize(path, type = path.split('.')[-1])
      # The type is js or css
      @type = type

      # Set up path
      (@path = path) =~ /(.*)-([a-f0-9]{1,32})\.(.*)/
      @path = path.gsub("-#{@md5}", '') if (@md5 = $2)

      # Name with extension
      @name = @path.split('/')[-1]

      # Generate key
      @key = genkey

      # If application, we load via manifest
      @files = []
      if @name =~ /application\.(js|css)/
        self.class.manifest[@type].each do |f|
          f.each{|k, v| @files << disk(k)}
        end
      else
        @files << disk
      end
    end

    # Generate key
    def genkey(m = @md5)
      "#{@path.gsub('/', '-')}#{m ? "-#{m}" : ''}.#{@type}"
    end

    # Digest, used for caching with timestamp
    def digest(m = timestamp)
      Digest::MD5.hexdigest(m.to_i.to_s)
    end

    # The cached content
    def cached
      begin
        File.read(cache) if @md5
      rescue
        # Return nil if supplied md5 is not valid
        return nil if @key != genkey(digest)

        # No cache found, cache it
        compressed.tap do |c|
          File.open(cache, 'w'){|f| f.write(c)}
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
      @files.map{|f| File.read(f) rescue nil}.compact.join
    end

    # The content on disk
    def content
      @content ||= @files.map{|f| File.read(f) rescue nil}.compact.join.tap{|c| return nil if c == ''}
    end

    # File absolute path, nil if it doesn't exist
    def disk(f = @path)
      File.join(::Asset.path, @type, f)
    end

    # Get the asset source, relative path
    def sources
      bundle? ? [bundle] : paths
    end

    # The application bundle
    def bundle
      %{/assets/#{@type}/application-#{digest}.#{@type}}
    end

    # Get the files as paths
    def paths
      @files.map do |f|
        m = File.mtime(f) rescue next if ::Asset.mode == 'production'
        f =~ /(\/assets\/(js|css)\/(.*)(\.(js|css)))/
        %{/assets/#{$2}/#{$3}#{m ? "-#{digest(m)}" : ''}#{$4}}
      end.compact
    end

    # Determine if we should bundle
    def bundle?
      ::Asset.mode == 'production' and @name == "application.#{@type}"
    end

    # Find the cache path
    def cache
      File.join('tmp', @key)
    end

    # Find the last modified timestamp
    def timestamp
      @timestamp ||= @files.map{|f| File.mtime(f) rescue nil}.compact.max
    end

    # Print data
    def to_s
      puts "TYPE: #{@type}"
      puts "PATH: #{@path}"
      puts "NAME: #{@name}"
      puts "MD5: #{@md5}"
      puts "KEY: #{@key}"
      puts "FILES: #{@files.inspect}"
      puts "CONTENT: #{content}"
      puts "MOD: #{timestamp}"
    end

    # Load the manifest from file and record the timestamps
    @manifest = YAML.load_file(File.join(::Asset.path, 'manifest.yml')).
    inject({}) do |q, (k, v)|
      q[k] = v.map do |l|
        {l => File.mtime(File.join(::Asset.path, k, l)).to_i}
      end; q
    end
  end
end
