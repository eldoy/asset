module Asset
  class Util

    # Turns a file name into a css link
    def self.style_tag(links)
      [links].flatten.map{|link| %{<link href="#{link}" media="all" rel="stylesheet" type="text/css">} }.join("\n")
    end

    # Turns a file name into a script tag
    def self.script_tag(links)
      [links].flatten.map{|link| %{<script src="#{link}"></script>} }.join("\n")
    end

    # Compress with sass
    def self.css_compress(str)
      Tilt.new('scss', {:style => :compressed}){ str }.render rescue str
    end

    # Compress with uglify
    def self.js_compress(str)
      Uglifier.compile(str, {}) rescue str
    end

    # Get the mtime of a file
    # DELETE
    def self.mtime(path)
      File.mtime(path)
    end

    # Create an md5 representation of a file
    def self.digest(path)
      Digest::MD5.file(path).hexdigest if File.file?(path)
    end

    # Setup a pack or item
    def self.asset(key, options = {})
      options = {:compress => MODE != 'development'}.merge(options)
      options[:compress] ? ::Asset::Pack.new(key, options) : ::Asset::Item.new(key, options)
    end

    # Load manifest
    def self.load_manifest
      # Load manifest
      begin
        YAML.load_file(File.join(APP_ASSETS, 'manifest.yml'))
      rescue
        puts "No manifest.yml file found at #{APP_ASSETS}"
        raise
      end
    end

  end
end
