test 'Helpers'

include ::Asset::Helpers

test 'image tag'

t = image_tag('bg.png')
is t, %{<img src="/assets/images/bg.png?1483144362">}

t = image_tag('logo/logo.png')
is t, %{<img src="/assets/images/logo/logo.png?1483144362">}

test 'script tag development'

::Asset.mode = 'development'

test ' * single'

tag = script_tag('app.js')
t = %{<script src="/assets/js/app.js"></script>}
is tag, t

test ' * multiple'

tag = script_tag('app.js', 'app.js')
is tag, "#{t}\n#{t}"

test ' * application'

tag = script_tag('application.js')

t = %{<script src="/assets/js/app.js"></script>
<script src="/assets/js/lib/cookie.js"></script>}
is tag, t


test 'script tag production'

::Asset.mode = 'production'

test ' * single'

tag = script_tag('app.js')
t = %{<script src="/assets/js/app-763c4fccc8568b3078f7f07a23f83736.js"></script>}
is tag, t

test ' * multiple'

tag = script_tag('app.js', 'app.js')
is tag, "#{t}\n#{t}"

test ' * application'

tag = script_tag('application.js')

t = %{<script src="/assets/js/application-763c4fccc8568b3078f7f07a23f83736.js"></script>}
is tag, t


test 'style tag development'

::Asset.mode = 'development'

test ' * single'

tag = style_tag('app.css')
t = %{<link href="/assets/css/app.css" media="all" rel="stylesheet" type="text/css">}
is tag, t

test ' * multiple'

tag = style_tag('app.css', 'app.css')
is tag, "#{t}\n#{t}"

test ' * application'

tag = style_tag('application.css')

t = %{<link href="/assets/css/app.css" media="all" rel="stylesheet" type="text/css">
<link href="/assets/css/themes/themes.css" media="all" rel="stylesheet" type="text/css">}
is tag, t


test 'style tag production'

::Asset.mode = 'production'

test ' * single'

tag = style_tag('app.css')
t = %{<link href="/assets/css/app-6c64d8f350f7d8e8393b62dd36409ccc.css" media="all" rel="stylesheet" type="text/css">}
is tag, t

test ' * multiple'

tag = style_tag('app.css', 'app.css')
is tag, "#{t}\n#{t}"

test ' * application'

tag = style_tag('application.css')

t = %{<link href="/assets/css/application-6c64d8f350f7d8e8393b62dd36409ccc.css" media="all" rel="stylesheet" type="text/css">}
is tag, t
