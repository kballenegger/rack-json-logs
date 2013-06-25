
# TODO: write actual unit tests :).

$: << File.expand_path('../lib/', __FILE__)
require 'rack-json-logs'

use Rack::JsonLogs

run ->(env) do
  puts "hello world"
  $stderr.puts "bye world"
  raise "exception on purpose"
  [200, {'Content-Type' => 'text/html'}, ['Hello Rack!']]
end
