Gem::Specification.new do |s|
  s.name        = 'asset'
  s.version     = '0.1.11'
  s.date        = '2017-01-25'
  s.summary     = "Compress and serve your CSS and JS assets automatically"
  s.description = "The only thing you need for your assets."
  s.authors     = ["Fugroup Limited"]
  s.email       = 'vidar@fugroup.net'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rack', '>= 0'
  s.add_runtime_dependency 'sass', '>= 0'
  s.add_runtime_dependency 'therubyracer', '>= 0'
  s.add_runtime_dependency 'uglifier', '>= 0'

  s.add_development_dependency 'sinatra', '>= 0'
  s.add_development_dependency 'puma', '>= 0'
  s.add_development_dependency 'liquid', '>= 0'
  s.add_development_dependency 'erubis', '>= 0'
  s.add_development_dependency 'rest-client', '>= 0'
  s.add_development_dependency 'request_store', '>= 0'
  s.add_development_dependency 'fuprint', '>= 0'
  s.add_development_dependency 'futest', '>= 0'
  s.add_development_dependency 'listen', '>= 0'

  s.homepage    = 'https://github.com/fugroup/asset'
  s.license     = 'MIT'

  s.require_paths = ['lib']
  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|app|config|log|tmp)/})
  end
end
