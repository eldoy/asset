test '* manifest'

m = ::Asset.manifest

item = m.first
is item.joined, :a? => String
is item.cached, :a? => String
