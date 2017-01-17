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
      list = Dir["#{Asset.path}/{css,js}/**/*"].select{|f| File.file?(f)}.map{|f| f.gsub(Asset.path + '/', '')}
      manifest = []
      list.each do |file|
        file =~ /(js|css)\/(.+)/
        type, name = $1, $2

        # Get the modified time of the asset
        modified = mtime("#{type}/#{name}")

        # Loading manifest with items
        manifest << ::Asset::Item.new(name, type, digest(name, modified), modified)
      end

      # Insert the css bundle
      max = manifest.select{|r| r.type == 'css'}.map{|r| r.modified}.max
      manifest.insert(0, ::Asset::Item.new('bundle.css', 'css', digest('bundle.css', max), max))

      # Insert the js bundle
      max = manifest.select{|r| r.type == 'js'}.map{|r| r.modified}.max
      manifest.insert(0, ::Asset::Item.new('bundle.js', 'js', digest('bundle.js', max), max))

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
