module Asset
  module Helpers

    # Use this helper in your view to use the assets
    def asset_url(key, options = {})
      ::Asset::Util.asset(key, options).asset_path
    end

    def style_tag(href)
      ::Asset::Util.style_tag(href)
    end

    def script_tag(src)
      ::Asset::Util.script_tag(src)
    end

    def image_url(name)
      timestamp = File.mtime(File.join(APP_ASSETS, 'images', File.split(name))).to_i.to_s
      "/images/#{CGI.escapeHTML(name)}?#{timestamp}"
    end

  end
end
