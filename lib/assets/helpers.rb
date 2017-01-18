module Asset
  module Helpers

    # Asset URL
    def asset_url(path)
      ::Asset.manifest.find{|i| i.path == path}.src rescue path
    end

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
      b = ::Asset.images[path] rescue nil
      # Just slip through if the path starts with http(s) or //
      src = path =~ /^(http[s]?)?:?\/\// ? path : %{/assets/images/#{path}}
      %{<img src="#{src}#{b ? "?#{b}" : ''}">}
    end

    private

    # Build the tags
    def tag(type, *paths, &block)
      paths.map do |path|
        # Yield the source back to the tag builder
        item = ::Asset.manifest.find{|i| i.path == path}

        # Src is same as path if item not found
        item ? item.sources.map{|f| yield(asset_url(f))} : yield(path)
      end.flatten.join("\n")
    end

  end
end
