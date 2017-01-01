test 'Item'

test 'app css fake md5, existing'

key = 'app-a1888dbd56e058ff1d827d261c12702b.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, nil


test 'app css deep md5, existing'

key = 'lib/app.min-452791b9192e41f88cebdd4b9f08543e.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, String
is store.cached.size, :gt => 0


test 'app deep path css no md5, non-existing'

key = 'lib/appylappy.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, nil
is store.key, String
is store.files, :a? => Array
is store.files.size, 1
is store.content, nil
is store.cached, nil


test 'app deep path css no md5, existing'

key = 'lib/app.min.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, nil
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, nil


test 'app css md5, existing'

key = 'appylappy.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, nil
is store.key, String
is store.files, :a? => Array
is store.files.size, 1
is store.content, nil
is store.cached, nil


test 'app css md5, non-existing'

key = 'appylappy-9e13f5f27b151f2c03d2966e06adc7b7.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, 1
is store.content, nil
is store.cached, nil


test 'app js no md5, non-existing'

key = 'appylappy.js'

store = ::Asset::Store.new(key)
is store.type, 'js'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, nil
is store.key, String
is store.files, :a? => Array
is store.files.size, 1
is store.content, nil
is store.cached, nil


test 'app js md5, non-existing'

key = 'appylappy-9e13f5f27b151f2c03d2966e06adc7b7.js'

store = ::Asset::Store.new(key)
is store.type, 'js'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, 1
is store.content, nil
is store.cached, nil


test 'app js md5, existing'

key = 'app-9e13f5f27b151f2c03d2966e06adc7b7.js'

store = ::Asset::Store.new(key)
is store.type, 'js'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, String
is store.cached.size, :gt => 0


test 'application css, double dot name, md5, non-existing'

key = 'app.min-452791b9192e41f88cebdd4b9f08543e.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, 1
is store.content, nil
is store.cached, nil


test 'application css, md5'

key = 'application-6c64d8f350f7d8e8393b62dd36409ccc.css'

store = ::Asset::Store.new(key)
is store.type, 'css'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, String
is store.cached.size, :gt => 0


test 'application js, md5'

key = 'application-9e13f5f27b151f2c03d2966e06adc7b7.js'

store = ::Asset::Store.new(key)
is store.type, 'js'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, String
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, String
is store.cached.size, :gt => 0


test 'existing file, no md5'

key = 'app.js'

store = ::Asset::Store.new(key)
is store.type, 'js'
is store.name, :a? => String
is store.path, :a? => String
is store.md5, nil
is store.key, String
is store.files, :a? => Array
is store.files.size, :gt => 0
is store.content, String
is store.cached, nil
