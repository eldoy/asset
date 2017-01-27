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
      Dir["#{Asset.path}/{css,js}/**/*.*"].map do |f|
        # Extract type and name
        f =~ /(js|css)\/(.+)$/; type, name = $1, $2

        # Loading manifest with items
        ::Asset::Item.new(name, type, digest(File.read(f)), mtime("#{type}/#{name}"))
      end
    end

    # Load bundles for js and css
    def self.load_bundle(type)
      # Find the items
      items = ::Asset.manifest.select{|r| r.type == type}

      # Find keys for digest and max modified time
      keys, max = items.map(&:key).join, items.map(&:modified).max

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
