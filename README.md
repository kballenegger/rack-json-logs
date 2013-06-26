# Rack::JsonLogs

Rack::JsonLogs is a gem that helps log sanely in production.

Ever request will log a JSON object to the real *stdout*, containing the
following (note: whitespace added here for clarity, in production it would only
be a single line, for easier processig through tools like `grep`):

```json
{
   "request": "GET /hello",
   "from": "server-1",
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

```
$ tail -F my.log | json-log-pp
    
Request: GET /hello
From: server-1

stdout:
hello world

stderr:
bye world

Exception: exception on purpose
  config.ru:12:in `block (2 levels) in <main>'
  /Users/kenneth/Dropbox/dev/azure/rack-json-logs/lib/rack-json-logs.rb:24:in `call'
  /Users/kenneth/Dropbox/dev/azure/rack-json-logs/lib/rack-json-logs.rb:24:in `call'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/connection.rb:81:in `block in pre_process'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/connection.rb:79:in `catch'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/connection.rb:79:in `pre_process'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/connection.rb:54:in `process'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/connection.rb:39:in `receive_data'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/eventmachine-1.0.0/lib/eventmachine.rb:187:in `run_machine'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/eventmachine-1.0.0/lib/eventmachine.rb:187:in `run'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/backends/base.rb:63:in `start'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/server.rb:159:in `start'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/controllers/controller.rb:86:in `start'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/runner.rb:187:in `run_command'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/lib/thin/runner.rb:152:in `run!'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/gems/thin-1.5.0/bin/thin:6:in `<top (required)>'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/bin/thin:19:in `load'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/bin/thin:19:in `<main>'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/bin/ruby_noexec_wrapper:14:in `eval'
  /Users/kenneth/.rvm/gems/ruby-1.9.3-p327/bin/ruby_noexec_wrapper:14:in `<main>'


Request: GET /hello
From: server-2

stdout:
hello world

stderr:
bye world
```


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
