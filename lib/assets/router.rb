module Asset
  class Router

    # Mime types
    MIME = {
      'js' => 'application/javascript; charset=UTF-8',
      'css' => 'text/css; charset=UTF-8',
      'txt' => 'text/plain; charset=UTF-8'
    }

    def initialize(app)
      @app = app
    end

    def call(env)
      # Setting up request
      @request = Rack::Request.new(env)

      # The routes
      case @request.path_info

      # Match /assets?/:type/path
      when /^(\/assets)?\/(js|css)\/(.+)/
        @store = ::Asset::Store.new($3, $2)
        (@result = @store.cached || @store.content) ? found : not_found

      # Bounce favicon requests
      when /^\/favicon\.ico$/
        not_found

      # Return a standard robots.txt
      when /^\/robots\.txt$/
        robots

      else
        # No routes found, pass down the middleware stack
        @app.call(env)
      end
    end

    private

    # Found
    def found
      [ 200, {
        'Content-Type' => MIME[@store.type],
        'Content-Length' => @store.content.size,
        'Cache-Control' => 'max-age=86400, public',
        'Expires' => (Time.now + 86400*30).utc.rfc2822,
        'Last-Modified' => @store.timestamp.utc.rfc2822
        }, [@result]]
    end

    # Not found
    def not_found
      puts "NOT FOUND!"
      [ 404, {
          'Content-Type' => MIME['txt'],
          'Content-Length' => 0
        }, []]
    end

    # Robots
    def robots
      s = %{Sitemap: #{@request.scheme}://#{@request.host}/sitemap.xml}
      [ 200, {
        'Content-Type' => MIME['txt'],
        'Content-Length' => s.size
        }, [s]]
    end

  end
end
