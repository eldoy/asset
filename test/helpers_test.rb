test 'Helpers'

include ::Asset::Helpers

::Asset.mode = 'development'

test 'asset url'

t = asset_url('app.js')
is t, %{/assets/js/app.js}

::Asset.mode = 'production'

t = asset_url('app.js')
is t, %{/assets/js/app-3e259351b6d47daf1d7c2567ce3914ab.js}

::Asset.mode = 'development'

test 'image tag'

url = 'http://fugroup.net/images/fugroup_logo1.png'
t = image_tag(url)
is t, %{<img src="#{url}">}

url = '//fugroup.net/images/fugroup_logo1.png'
t = image_tag(url)
is t, %{<img src="#{url}">}

t = image_tag('bg.png')
is t, %{<img src="/images/bg.png?1483144362">}

t = image_tag('logo/logo.png')
is t, %{<img src="/images/logo/logo.png?1483144362">}

test 'script tag development'

::Asset.mode = 'development'

test ' * single'

url = 'https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.21.0/codemirror.js'
tag = script_tag(url)
t = %{<script src="#{url}"></script>}
is tag, t

url = '//cdnjs.cloudflare.com/ajax/libs/codemirror/5.21.0/codemirror.js'
tag = script_tag(url)
t = %{<script src="#{url}"></script>}
is tag, t

tag = script_tag('app.js')
t = %{<script src="/assets/js/app.js"></script>}
is tag, t

test ' * multiple'

tag = script_tag('app.js', 'app.js')
is tag, "#{t}\n#{t}"

test ' * bundle'

tag = script_tag('bundle.js')

t = %{<script src="/assets/js/app.js"></script>
<script src="/assets/js/lib/cookie.js"></script>}
is tag, t

test 'script tag production'

::Asset.mode = 'production'

test ' * single'

tag = script_tag('app.js')
t = %{<script src="/assets/js/app-3e259351b6d47daf1d7c2567ce3914ab.js"></script>}
is tag, t

test ' * multiple'

tag = script_tag('app.js', 'app.js')
is tag, "#{t}\n#{t}"

test ' * bundle'

tag = script_tag('bundle.js')
t = %{<script src="/assets/js/bundle-9564d87b6d05447bc613ebd1a2d086e2.js"></script>}
is tag, t

test '** should not write digest directly'
tag = script_tag('bundle-9564d87b6d05447bc613ebd1a2d086e2.js')
t = %{<script src="bundle-9564d87b6d05447bc613ebd1a2d086e2.js"></script>}
is tag, t


test 'style tag development'

::Asset.mode = 'development'

test ' * single'

tag = style_tag('app.css')
t = %{<link href="/assets/css/app.css" media="all" rel="stylesheet" type="text/css">}
is tag, t

tag = style_tag('themes/large-badges.css')
t = %{<link href="/assets/css/themes/large-badges.css" media="all" rel="stylesheet" type="text/css">}
is tag, t

test ' * multiple'

tag = style_tag('app.css', 'app.css')
t = %{<link href="/assets/css/app.css" media="all" rel="stylesheet" type="text/css">}
is tag, "#{t}\n#{t}"


test ' * bundle'

tag = style_tag('bundle.css')

t = %{<link href="/assets/css/app.css" media="all" rel="stylesheet" type="text/css">
<link href="/assets/css/themes/themes.css" media="all" rel="stylesheet" type="text/css">}
is tag, t

tag = script_tag('bundle.js')

t = %{<script src="/assets/js/app.js"></script>
<script src="/assets/js/lib/cookie.js"></script>}
is tag, t


test 'style tag production'

::Asset.mode = 'production'

test ' * single'

tag = style_tag('app.css')
t = %{<link href="/assets/css/app-562b912c572fd5bb67b0de2257b82acb.css" media="all" rel="stylesheet" type="text/css">}
is tag, t

test ' * multiple'

tag = style_tag('app.css', 'app.css')
is tag, "#{t}\n#{t}"

test ' * bundle'

tag = style_tag('bundle.css')

t = %{<link href="/assets/css/bundle-e91f9f61352f603d27d25cfe44234bb8.css" media="all" rel="stylesheet" type="text/css">}
is tag, t
