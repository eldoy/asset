module Asset
  class Router

    CONTENT_TYPES = {'js' => 'application/javascript', 'css' => 'text/css'}

    def initialize(app)
      @app = app
    end

    def call(env)
      # Matching any paths coming from
      if env['PATH_INFO'] =~ /(\/assets)?\/(js|css)\/(.+)/
        @pack = ::Asset::Pack.new($2, $3)
        @pack.content ? [200, headers, [@pack.content]] : not_found
      else
        @app.call(env)
      end
    end

    private

    # Not found
    def not_found
      puts "NOT FOUND!"
      [404, {'Content-Type' => 'text/html', 'Content-Length' => 0}, []]
    end

    # Default headers, content type and caching
    def headers(options = {})
      {
        'Content-Type' => CONTENT_TYPES[@pack.type],
        'Content-Length' => @pack.content.size,
        'Cache-Control' => 'max-age=86400, public',
        'Expires' => (Time.now + 86400*30).utc.rfc2822,
        'Last-Modified' => Time.at(@pack.modified).utc.rfc2822
      }.merge(options)
    end

  end
end

  #   # Server favicon
  #   get('/favicon.ico') do
  #     404
  #   end

  #   # The robots file
  #   get('/robots.txt') do
  #     "Sitemap: #{request.scheme}://#{request.host}/sitemap.xml"
  #   end

  #   # Asset path for compressed assets
  #   get('/assets/*') do
  #     asset_path
  #   end

  #   # Legacy routes

  #   get('/js/*') do
  #     asset_path
  #   end

  #   get('/css/*') do
  #     asset_path
  #   end

  #   private

  #   # Asset URLs may looks like this: application-90892393512a7d2397dd63ad6f26b9aa.css
  #   def asset_path
  #     key = params['splat'][0]
  #     key =~ /(.*)-([a-f0-9]{1,32})\.(.*)/

  #     # Extract asset URL name, type and md5
  #     name, type, md5 = $1, $3, $2
  #     #name, type = key.split('.') if !md5
  #     name, dot, type = key.rpartition('.') if !md5

  #     # Halt
  #     halt 404 if !(name and type and %w[css js].include?(type))

  #     options = {:compress => !!md5}
  #     obj = name == 'application' ? Pack.new("#{name}.#{type}", options) : Asset.new("#{name}.#{type}", options)

  #     halt 404 unless obj.asset_path

  #     content_type type.to_sym

  #     expires 86400*30, :public
  #     last_modified obj.modified
  #     # Add etag as well? etag Digest::MD5.hexdigest(obj.content)

  #     obj.content
  #   end

  # end
# end
