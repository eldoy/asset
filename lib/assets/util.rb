module Asset
  class Util

    # Setup assets
    def self.setup!
      # Load the manifest
      ::Asset.manifest = load_manifest

      # Load the bundle
      ::Asset.bundle = YAML.load_file(File.join(::Asset.path, 'manifest.yml'))

      # Load the images
      ::Asset.images = load_images
    end

    # Get timestamp
    def self.mtime(path)
      File.mtime(asset_path(path)).utc
    end

    # Asset path
    def self.asset_path(path)
      File.join(::Asset.path, path)
    end

    # Digest
    def self.digest(string)
      Digest::MD5.hexdigest(string)
    end

    # Load manifest
    def self.load_manifest
      manifest = []
      list = Dir["#{Asset.path}/{css,js}/**/*"].select{|f| File.file?(f)}.each do |file|
        # Extract type and name
        file =~ /(js|css)\/(.+)$/; type, name = $1, $2

        # Get the modified time
        # Get the modified time of the asset
        modified = mtime("#{type}/#{name}")

        # Loading manifest with items
        manifest << ::Asset::Item.new(name, type, digest(File.read(file)), modified)
      end

      # Insert the css bundle
      css = manifest.select{|r| r.type == 'css'}
      # Get the max modified date and the keys
      max, keys = css.map{|r| r.modified}.max, css.map{|r| r.key}.join
      manifest.insert(0, ::Asset::Item.new('bundle.css', 'css', digest(keys), max))

      # Insert the js bundle
      js = manifest.select{|r| r.type == 'js'}
      # Get the max modified date and the keys
      max, keys = js.map{|r| r.modified}.max, js.map{|r| r.key}.join
      manifest.insert(0, ::Asset::Item.new('bundle.js', 'js', digest(keys), max))

      manifest
    end

    # Load images into memory
    def self.load_images
      # Store the path and the timestamp
      images = Dir["#{::Asset.path}/images/**/*"].select{|f| File.file?(f)}.map do |i|
        i =~ /\/images\/(.+)/; [$1, mtime("images/#{$1}").to_i]
      end
      Hash[*images.flatten]
    end

  end
end
