module Asset
  # The Router class is a small Rack middleware that matches the asset URLs
  # and serves the content, compressed if you are in production mode.
  class Router

    # Mime types for responses
    MIME = {'js' => 'application/javascript;charset=utf-8', 'css' => 'text/css;charset=utf-8', 'txt' => 'text/plain;charset=utf-8'}

    # Init
    def initialize(app)
      @app = app
    end

    # Thread safe
    def call(env)
      dup.call!(env)
    end

    # Call
    def call!(env)
      # Setting up request
      @request = ::Rack::Request.new(env)

      # The routes
      case @request.path_info

      # Match /assets?/:type/path
      when /^(\/assets)?\/(js|css)\/(.+)/
        # Extract type and path
        type, path = $2, $3

        # Extract digest key and remove from path
        path.gsub!("-#{@key = $1}", '') if path =~ /-([a-f0-9]{32})\.(css|js)$/

        # Find the item
        item = ::Asset.manifest.find{|i| i.path == path and i.type == type}

        # Return the content or not found
        item ? found(item) : not_found

      # Bounce favicon requests
      when (::Asset.favicon and /^\/favicon\.ico$/)
        not_found

      # Return a standard robots.txt
      when (::Asset.robots and /^\/robots\.txt$/)
        robots

      else
        # No routes found, pass down the middleware stack
        @app.call(env)
      end
    end

    private

    # Found
    def found(item)
      content = item.content(!!@key)
      [ 200, {'Content-Type' => MIME[item.type],
        'Content-Length' => content.bytesize,
        'Cache-Control' => 'public, max-age=86400',
        'Expires' => (Time.now.utc + (86400 * 30)).httpdate,
        'Last-Modified' => item.modified.httpdate,
      }, [content]]
    end

    # Not found
    def not_found
      [404, {'Content-Type' => MIME['txt'], 'Content-Length' => 0}, []]
    end

    # Robots
    def robots
      s = %{Sitemap: #{@request.scheme}://#{@request.host}/sitemap.xml}
      [200, {'Content-Type' => MIME['txt'],'Content-Length' => s.bytesize}, [s]]
    end

  end
end
