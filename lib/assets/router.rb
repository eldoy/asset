module Asset
  class Router

    # Mime types
    MIME = {'js' => 'application/javascript; charset=UTF-8', 'css' => 'text/css; charset=UTF-8', 'txt' => 'text/plain; charset=UTF-8'}

    # Init
    def initialize(app)
      @app = app
    end

    # Call
    def call(env)
      # Setting up request
      @request = Rack::Request.new(env)

      # The routes
      case @request.path_info

      # Match /assets?/:type/path
      when /^(\/assets)?\/(js|css)\/(.+)/
        type, path = $2, $3
        path =~ /-([a-f0-9]{1,32})\.(css|js)$/
        path.gsub!("-#{@key}", '') if (@key = $1)

        # Find the item
        item = ::Asset.manifest.find{|i| i.path == path and i.type == type}

        # Not found if no item, wrong key or no content
        return not_found if !item or (@key and @key != item.key) or !item.content(@key)

        found(item)

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
      [ 200, {'Content-Type' => MIME[item.type],
        'Content-Length' => item.content(@key).size,
        'Cache-Control' => 'max-age=86400, public',
        'Expires' => (Time.now + 86400*30).utc.rfc2822,
        'Last-Modified' => item.modified.utc.rfc2822
        }, [item.content(@key)]]
    end

    # Not found
    def not_found(path = '@')
      [404, {'Content-Type' => MIME['txt'], 'Content-Length' => 0}, []]
    end

    # Robots
    def robots
      s = %{Sitemap: #{@request.scheme}://#{@request.host}/sitemap.xml}
      [200, {'Content-Type' => MIME['txt'],'Content-Length' => s.size}, [s]]
    end

  end
end
