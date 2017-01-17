test 'Item'

::Asset.mode = 'development'

m = ::Asset.manifest

test '* bundle'

is m, :a? => Array
is m.size, :gt => 2
item = m.first
is item, :a? => ::Asset::Item
is item.path, 'bundle.js'
is item.key, :a? => String
is item.modified, :a? => Time
is item.files, :a? => Array
is item.files.size, :gt => 1
::Asset.mode = 'production'
is item.files.size, 1
::Asset.mode = 'development'

test '* file'

item = m.last
is item.path, 'lib/cookie.js'
is item.src, '/assets/js/lib/cookie.js'
is item.key, :a? => String
is item.modified, :a? => Time
is item.files, :a? => Array
is item.files.size, 1
::Asset.mode = 'development'
is item.files.size, 1

test '* content'

# Find item
is item.content(item.key), :a? => String
is item.content(item.key).split("\n").size, 1
