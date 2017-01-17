# Asset compresses and serves your CSS and JS files

Compress and cache your Javascript and CSS files automatically.

Set up your manifest file, install the helpers and the middleware, and you're up and running with compressed assets served lightning fast on pure in-memory Ruby Rack.

### Installation
```
gem install asset
```
or add to Gemfile. In your Rack app include the line
```ruby
# Rack apps
include Asset::Router

# Sinatra
helpers Asset::Router
```

### Settings
```ruby
# Default is development
@mode = ENV['RACK_ENV'] || 'development'

# Where your assets live
@path = File.join(Dir.pwd, 'app', 'assets')

# Where to write the cache, default to APP_ROOT/tmp
@cache = File.join(Dir.pwd, 'tmp')

# Automatically bounce (404) for browser /favicon.ico requests
@favicon = true

# Send /robots.txt to a standard robots txt with reference to /sitemap.xml
@robots = true

# Debug option
@debug = false
```

### Usage
```yaml
# Install your manifest file in APP_ROOT/app/assets/manifest.yml

# Asset manifest. Only the files mentioned here will be bundled.
css:
- app.css
- themes/themes.css

js:
- app.js
- lib/cookie.js
```

```erb
# After setting up the manifest file, use the helpers in your views
<%= script_tag 'app.js' %>
<%= style_tag 'app.css' %>

# Multiple
<%= script_tag 'app.js', 'lib/cookies.js' %>

# Bundle all Javscript files with 'bundle.js'
<%= script_tag 'bundle.js' %>

# Bundle all CSS files with 'bundle.css'
<%= script_tag 'bundle.css' %>
```

In development mode, all files will be printed. In production mode, you'll get only one file.

The file will also be cached and compressed. The cache auto-expires, but if you're storing the cache on disk you can clean it with a cron job.

### Middleware

The Asset gem also comes with Rack middleware to handle requests for your assets.

```ruby
# Insert the asset middleware early in the stack
use Asset::Router

# Full example from the config.ru file

# Set up middleware stack
app = Rack::Builder.new do
  use Asset::Router # Include the Asset middleware router

  # Use this setup to have files served from /assets/images and /assets/fonts
  use Rack::Static, :urls => ['/images', '/fonts'], :root => APP_ASSETS,
    :header_rules => [
      [:all, {'Cache-Control' => 'public, max-age=31536000'}],
      [:fonts, {'Access-Control-Allow-Origin' => '*'}]
    ]
  run App # Your app goes here
end

run app

# Files will be available here on your server (HTTP):
/assets/js/app.js
/assets/js/lib/app.js
/assets/css/app.css
/assets/css/themes/dark.css

# You can also drop the /assets in front
/js/app.js
/css/app.css
```

The helpers will generate these URLs, so you don't have to worry about it.

### Images and fonts

To include support for other static file types likes images and fonts, use [Rack::Static,](https://github.com/rack/rack/blob/master/lib/rack/static.rb) see the example above.


We've included an image tag helper too for this use:
```erb
# Use this in your application, will default to APP_ROOT/assets/images
<%= image_tag 'logo.png' %>
```

### Contribute

Created and maintained by [Fugroup Ltd.](https://www.fugroup.net) We are the creators of [CrowdfundHQ.](https://crowdfundhq.com)

`@authors: Vidar`
