module Asset
  class Util

    # Get timestamp
    def self.mtime(path)
      File.mtime(asset_path(path)).utc
    end

    # Asset path
    def self.asset_path(path)
      File.join(::Asset.path, path)
    end

    # Digest
    def self.digest(path, time = mtime(path))
      Digest::MD5.hexdigest(%{#{path}#{time.to_i}})
    end

    # Load manifest
    def self.load_manifest
      list = YAML.load_file(File.join(::Asset.path, 'manifest.yml'))
      manifest = []

      list.each do |type, files|
        max = Time.new(0).utc
        files.each do |name|

          # Get the modified time of the asset
          modified = mtime("#{type}/#{name}")

          # Record max to know the latest change
          max = modified if modified > max

          # Loading manifest with items
          manifest << ::Asset::Item.new(
            name, type, digest(name, modified), modified)
        end

        # Insert the bundle
        manifest.insert(0, ::Asset::Item.new(
          "bundle.#{type}", type,
          digest("bundle.#{type}", max), max))
      end
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
