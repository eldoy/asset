require './config/boot'

include Futest::Helpers

@host = 'http://localhost:4000'

# Load tests. Comment out the ones you don't want to run.
begin
  start = Time.now
  [
    'router',
    'bonus',
    'helpers',
    'manifest'

  ].each{|t| require_relative "#{t}_test"}
rescue => x
  puts x.message
  err(x)
ensure
  puts Time.now - start
end
