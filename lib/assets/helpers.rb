module Asset
  module Helpers

    # Script tags
    def script_tag(*paths)
      tag('js', *paths) do |src|
        %{<script src="#{src}"></script>}
      end
    end

    # Style tags
    def style_tag(*paths)
      tag('css', *paths) do |src|
        %{<link href="#{src}" media="all" rel="stylesheet" type="text/css">}
      end
    end

    # Image tags
    def image_tag(path)
      %{<img src="/assets/images/#{CGI.escapeHTML(path)}#{(s = stamp(path)) ? "?#{s}" : ''}">} rescue path
    end

    private

    # Build the tags
    def tag(type, *paths, &block)
      paths.map do |path|
        # Yield the source back to the tag builder
        item = ::Asset.manifest.find{|i| i.path == path}

        if !item
          yield(path); next
        end

        item.files.map{|src| yield(%{/assets/#{type}/#{src}})}

      end.flatten.join("\n")
    end

    # Get timestamp
    def stamp(path)
      File.mtime(File.join(::Asset.path, 'images', File.split(path))).to_i.to_s
    end

  end
end
