
# TODO: write actual unit tests :).

$: << File.expand_path('../lib/', __FILE__)
require 'rack-json-logs'

use Rack::JsonLogs

run ->(env) do
  [200, {'Content-Type' => 'text/html'}, ['Hello Rack!']]
end
