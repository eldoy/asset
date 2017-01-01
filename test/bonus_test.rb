test 'Bonus'

test 'favicon'

pull '/favicon.ico' rescue @code = 404
is @code, 404


test 'robots'

pull '/robots.txt' rescue @code = 404
is @code, 200
is @body.include?('Sitemap'), true
