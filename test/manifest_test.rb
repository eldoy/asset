test 'manifest'

is ::Asset.manifest, :a? => Hash
is ::Asset.manifest['css'], :a? => Array
is ::Asset.manifest['css'].first, :a? => Hash
is ::Asset.manifest['js'], :a? => Array
is ::Asset.manifest['js'].first, :a? => Hash
is ::Asset.manifest['css'][0]['app.css'], :a? => Hash
is ::Asset.manifest['css'][0]['app.css']['key'], :a? => String
is ::Asset.manifest['css'][0]['app.css']['compress'], true
is ::Asset.manifest['css'][0]['app.css']['bundle'], true
is ::Asset.manifest['js'][0]['app.js']['key'], :a? => String
is ::Asset.manifest['js'][0]['app.js']['compress'], true
is ::Asset.manifest['js'][0]['app.js']['bundle'], true
is ::Asset.manifest['css'][1]['themes/themes.css']['bundle'], false
is ::Asset.manifest['css'][1]['themes/themes.css']['compress'], false
