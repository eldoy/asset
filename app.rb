class App < Sinatra::Base

  helpers Asset::Helpers

  configure do
    # Settings
    set :app_file, __FILE__
    set :root, APP_ROOT
    set :views, APP_VIEWS

    # Turn this on in dev to see handler
    set :show_exceptions, MODE != 'production'
    set :raise_errors, false

    # Haml setup
    set :haml, {:format => :html5}
    set :haml, :layout => :'layout/layout'
    set :sass, {:cache_location => './tmp/sass-cache'}

    # Liquid setup
    Liquid::Template.file_system = Liquid::LocalFileSystem.new(APP_VIEWS)

    # Set up loggers and tmp files
    Dir.mkdir('./tmp') unless File.exists?('./tmp')
    Dir.mkdir('./log') unless File.exists?('./log')

    # Global loggers
    $log = Logger.new("./log/app.log")
    $errors = Logger.new("./log/errors.log")
  end

  # Disable caching of classes when not in production
  configure :development, :test do |c|
    Liquid.cache_classes = false
    Liquid::Template.error_mode = :strict
  end

  get('/') do
    erb(:index)
  end

  # Default not found page
  not_found do
    "404, Not found".tap{|m| puts m}
  end

  # Default error pages
  error(500..510) do
    "50X, Application error".tap{|m| puts m}
  end

end
