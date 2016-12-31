module Asset
  class Print
    def initialize(app)
      @app = app
    end

    def call(env)
      r = Rack::Request.new(env)

      begin
        puts "\n\nIncoming Request:"
        puts "@ #{r.request_method.upcase} #{r.fullpath}"
        puts "$ #{r.params}"
      rescue => e
        puts "! #{e}"
      end

      @app.call(env)
    end
  end
end
