module Asset
  class Router

    CONTENT_TYPES = {'js' => 'application/javascript', 'css' => 'text/css'}

    def initialize(app)
      @app = app
    end

    def call(env)
      # Matching any paths for /assets/:type/:path
      if env['PATH_INFO'] =~ /(\/assets)?\/(js|css)\/(.+)/
        @store = ::Asset::Store.new($3, $2)
        @result = @store.cached || @store.content
        @result ? found : not_found
      else
        # No routes found, pass down the middleware stack
        @app.call(env)
      end
    end

    private

    # Found
    def found
      [200, headers, [@result]]
    end

    # Not found
    def not_found
      puts "NOT FOUND!"
      [404, {'Content-Type' => 'text/plain; charset=UTF-8', 'Content-Length' => 0}, []]
    end

    # Default headers, content type and caching
    def headers(options = {})
      {
        'Content-Type' => "#{CONTENT_TYPES[@store.type]}; charset=UTF-8",
        'Content-Length' => @store.content.size,
        'Cache-Control' => 'max-age=86400, public',
        'Expires' => (Time.now + 86400*30).utc.rfc2822,
        'Last-Modified' => @store.modified.utc.rfc2822
      }.merge(options)
    end

  end
end

# TODO:
#   # Server favicon
#   get('/favicon.ico') do
#     404
#   end

#   # The robots file
#   get('/robots.txt') do
#     "Sitemap: #{request.scheme}://#{request.host}/sitemap.xml"
#   end
