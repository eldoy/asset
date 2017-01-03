Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Init the app
require './config/boot.rb'
require './app.rb'

# Set up middleware stack
app = Rack::Builder.new do
  use Fuprint::Request
  use Asset::Router
  use Rack::Static, :urls => ['/images', '/fonts'], :root => APP_ASSETS,
    :header_rules => [
      [:all, {'Cache-Control' => 'public, max-age=31536000'}],
      [:fonts, {'Access-Control-Allow-Origin' => '*'}]
    ]
  run App
end

run app

