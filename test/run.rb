require './config/boot'

include Futest::Helpers

puts "Waiting for web server"
sleep 1

# Load tests. Comment out the ones you don't want to run.
begin
  start = Time.now
  [
    'features'
  ].each{|t| require_relative "#{t}_test"}
rescue => x
  puts x.message
  err(x)
ensure
  puts Time.now - start
end
