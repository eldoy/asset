test 'Bonus'

test 'favicon'

pull '/favicon.ico'
is @code, 404


test 'robots'

pull '/robots.txt'
is @code, 200
is @body.include?('Sitemap')
