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
include Asset::Helpers

# Sinatra
helpers Asset::Helpers
```

### Settings
```ruby
Asset.mode = ENV['RACK_ENV'] || MODE rescue 'development'
Asset.path = APP_ASSETS rescue File.join(Dir.pwd, 'app', 'assets')
Asset.cache = File.join(Dir.pwd, 'tmp')
Asset.debug = false
```

### Usage
```yaml
# Install your manifest file in APP_ROOT/app/assets/manifest.yml

# Asset manifest. Only the files mentioned here will be available.
# Options are compress: true/false, bundle: true/false
css:
- app.css
- themes/themes.css

js:
- app.js
- lib/cookie.js

# Example with options:
css:
- app.css:
  - compress: true
  - bundle: false
- themes/themes.css

js:
- app.js:
  - bundle: false
- lib/cookie.js
```

```ruby
# After setting up the manifest file, use the helpers in your views
<%= script_tag 'app.js' %>
<%= style_tag 'app.css' %>

# Multiple
<%= script_tag 'app.js', 'lib/cookies.js' %>

# Bundle all files with 'application.js'
<%= script_tag 'application.js' %>

# Bundle all files with 'application.css'
<%= script_tag 'application.css' %>
```

In development mode, all files will be printed. In production mode, you'll get only one file.

The file will also be cached and compressed. The cache auto-expires.

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

To include support for other static file types likes images and fonts, use [Rack::Static](https://github.com/rack/rack/blob/master/lib/rack/static.rb)

```ruby
use Rack::Static, :urls => ['/images', '/fonts'], :root => APP_ASSETS,
  :header_rules => [
    [:all, {'Cache-Control' => 'public, max-age=31536000'}],
    [:fonts, {'Access-Control-Allow-Origin' => '*'}]
  ]
```

We've included an image tag helper too for this use:
```erb
# Use this in your application, will default to APP_ROOT/assets/images
<%= image_tag 'logo.png' %>
```

### Contribute

Created and maintained by [Fugroup Ltd.](https://www.fugroup.net) We are the creators of [CrowdfundHQ.](https://crowdfundhq.com)

`@authors: Vidar`
