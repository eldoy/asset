module Asset
  class Util

    # Setup assets
    def self.setup!
      # Load the manifest
      ::Asset.manifest = load_manifest

      # Insert bundles
      %w[css js].each{|type| load_bundle(type)}

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

      Dir["#{Asset.path}/{css,js}/**/*.{css,js}"].each do |file|
        # Extract type and name
        file =~ /(js|css)\/(.+)$/; type, name = $1, $2

        # Get the modified time of the asset
        modified = mtime("#{type}/#{name}")

        # Loading manifest with items
        manifest << ::Asset::Item.new(name, type, digest(File.read(file)), modified)
      end

      manifest
    end

    # Load bundles for js and css
    def self.load_bundle(type)
      # Insert the bundle
      a = ::Asset.manifest.select{|r| r.type == type}

      # Get the max modified date and the keys
      max, keys = a.map{|r| r.modified}.max, a.map{|r| r.key}.join

      # Insert the bundle into the manifest
      ::Asset.manifest.insert(0, ::Asset::Item.new("bundle.#{type}", type, digest(keys), max))
    end

    # Load images into memory
    def self.load_images
      # Store the path and the timestamp
      img = Dir["#{::Asset.path}/images/**/*.*"].map do |i|
        i =~ /\/images\/(.+)/; [$1, mtime("images/#{$1}").to_i]
      end
      Hash[*img.flatten]
    end

  end
end
