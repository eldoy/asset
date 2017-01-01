test 'Features'

puts "Waiting for web server"
sleep 1


@host = 'http://localhost:4000'
pull

is @body.include?('Welcome to Assets'), true

pull '/assets/js/app.js'
is @code, 200

pull '/js/app.js'
is @code, 200

pull '/assets/css/app.js'
is @code, 200

pull '/css/app.js'
is @code, 200

pull '/assets/css/404.js' rescue @code = 404
is @code, 404

pull '/assets/js/404.js' rescue @code = 404
is @code, 404

# pull '/assets/js/app-51888dad56e056ff1d827d261c12702b.js'
# is @code, 200
