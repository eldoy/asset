module Asset
  class Router

    CONTENT_TYPES = {'js' => 'application/javascript', 'css' => 'text/css'}

    def initialize(app)
      @app = app
    end

    def call(env)
      @request = Rack::Request.new(env)

      puts "FROM ASSETS"
      puts

      # Matching any paths coming from
      if @request.path_info =~ /(\/assets)?\/(js|css)\/(.+)/
        type, path = $2, $3

        puts type
        puts path

        path =~ /(.*)-([a-f0-9]{1,32})\.(.*)/

        # Extract asset URL name, type and md5
        name, md5, ext, md5 = $1, $2, $3

        # Images, fonts and direct links don't have md5's
        name, dot, type = path.rpartition('.') if !md5



        # JS and CSS has md5
        # if md5

        name, dot, type = path.rpartition('.') if !md5
        key = "#{name}.#{type}"

        puts "NAME: #{name}"
        puts "TYPE: #{type}"
        puts "MD5: #{md5}"
        puts "KEY: #{key}"

        # Return 404 unless name and type
        return not_found unless name and type

        # Return 404 unless file exists
        return not_found unless File.file?(File.join(APP_ASSETS, type, key))

        begin
          q = ::Asset::Util.asset(key)

          # Return if no path found
          return not_found unless q.asset_path

          puts q.asset_path

          # Set headers for content and cache
          headers = {
            'Content-Type' => CONTENT_TYPES[type],
            'Content-Length' => q.content.size,
            'Cache-Control' => 'max-age=86400, public',
            'Expires' => (Time.now + 86400*30).utc.rfc2822,
            'Last-Modified' => Time.at(q.modified).utc.rfc2822
          }
          [200, headers, [q.content]]

        rescue => x
          puts x.message
          not_found
        end

      else
        @app.call(env)
      end

    end

    private

    def not_found
      puts "NOT FOUND!"
      [404, {'Content-Type' => 'text/html'}, []]
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
