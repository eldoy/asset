require './config/boot'

include Futest::Helpers

# Wipe cache
Pathname.new(::Asset.cache).children.each{|p| p.unlink}

sleep 1 # Wait for server
@host = 'http://localhost:4000'

# Load tests. Comment out the ones you don't want to run.
begin
  start = Time.now
  [
    'images',
    'router',
    'bonus',
    'helpers',
    'item'
  ].each{|t| require_relative "#{t}_test"}
rescue => x
  err x, :vv
ensure
  puts Time.now - start
end
