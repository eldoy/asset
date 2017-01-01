test 'Router'

puts "Waiting for web server"
sleep 1

pull

test 'welcome'

is @body.include?('Welcome to Assets'), true

test 'found, no md5'

pull '/assets/js/app.js'
is @code, 200

pull '/js/app.js'
is @code, 200

test 'not found, no md5'

pull '/assets/css/app.js' rescue @code = 404
is @code, 404

pull '/css/app.js' rescue @code = 404
is @code, 404

pull '/assets/css/404.js' rescue @code = 404
is @code, 404

pull '/assets/js/404.js' rescue @code = 404
is @code, 404

test 'found, md5'

pull '/assets/js/app-51888dad56e056ff1d827d261c12702b.js'
is @code, 200

test 'not found, wrong md5'
pull '/assets/css/app-a1888dbd56e058ff1d827d261c12702b.css'
is @code, 200
is @body.split("\n").size, :gt => 1

