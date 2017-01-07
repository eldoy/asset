test 'Router'

pull

test 'welcome'

is @body.include?('Welcome to Assets'), true

test 'found, no md5'

pull '/assets/js/app.js'
is @code, 200
is @body.split("\n").size, :gt => 1

pull '/js/app.js'
is @code, 200
is @body.split("\n").size, :gt => 1

test 'not found, no md5'

pull '/assets/css/app.js'
is @code, 404

pull '/css/app.js'
is @code, 404

pull '/assets/css/404.js'
is @code, 404

pull '/assets/js/404.js'
is @code, 404

test 'found, md5'

# Find item
item = ::Asset.manifest.find{|i| i.path == 'app.js'}
pull "/assets/js/#{item.kpath}"
is @code, 200
is @body.split("\n").size, 1

test 'not found, wrong md5'
pull '/assets/css/app-a1888dbd56e058ff1d827a261c12702b.css'
is @code, 404

test 'compress false'

item = ::Asset.manifest.find{|i| i.path == 'themes/themes.css'}
pull "/assets/css/#{item.kpath}"

is @code, 200
is @body.split("\n").size, :gt => 1
