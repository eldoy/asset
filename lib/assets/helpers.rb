module Asset
  module Helpers

    # Script tags
    def script_tag(*paths)
      asset(*paths) do |src|
        %{<script src="#{src}"></script>}
      end
    end

    # Style tags
    def style_tag(*paths)
      asset(*paths) do |src|
        %{<link href="#{src}" media="all" rel="stylesheet" type="text/css">}
      end
    end

    # Image tags
    def image_tag(path)
      %{<img src="/assets/images/#{CGI.escapeHTML(path)}#{(s = stamp(path)) ? "?#{s}" : ''}">} rescue path
    end

    private

    # Build the assets
    def asset(*paths, &block)
      paths.map do |path|
        store = ::Asset::Store.new(path)
        store.sources.map{|src| yield(src)}
      end.flatten.join("\n")
    end

    # Get timestamp
    def stamp(path)
      File.mtime(File.join(APP_ASSETS, 'images', File.split(path))).to_i.to_s
    end

  end
end
