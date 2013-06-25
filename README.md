# Rack::JsonLogs

Rack::JsonLogs is a gem that helps log sanely in production.

Ever request will log a JSON object to the real *stdout*, containing the
following (note: whitespace added here for clarity, in production it would only
be a single line, for easier processig through tools like `grep`):

```json
{
   "request": "GET /hello",
   "stdout": "This contains the STDOUT\nLines are separated by \\n",
   "stderr": "This contains the STDERR\nLines are separated by \\n",
   "exception": {
      "message": "Throwing an exception on purpose.",
      "backtrace": [
         "config.ru:9:in `block (2 levels) in <main>'",
         ".../rack-json-logs/lib/rack-json-logs.rb:23:in `call'",
         ".../rack-json-logs/lib/rack-json-logs.rb:23:in `call'",
         "etc... you get the idea"
      ]
   }
}
```

Rack::JsonLogs comes with a command-line tool to which you can pipe the log
files, which will be pretty-printed for legibility and in color:

    $ tail -F my.log | json-log-pp

## Installation

Add this line to your application's Gemfile:

    gem 'rack-json-logs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-json-logs

## Usage

Using Rack::JsonLogs is easy, all you need to do is add it to your middleware
stack:

```ruby
use Rack::JsonLogger
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
