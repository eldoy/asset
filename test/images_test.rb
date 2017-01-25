test 'Images'

images = ::Asset.images

is images, :a? => Hash
image = ::Asset.images.first
is image, :a? => Array
is image.first, :a? => String
is image.first, 'bg.png'
is image.last, :a? => Integer
is images['shared/morning.jpg']
