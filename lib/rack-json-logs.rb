require 'rack-json-logs/version'
require 'json'
require 'stringio'
require 'socket'

module Rack

  # JsonLogs is a rack middleware that will buffer output, capture exceptions,
  # and log the entire thing as a json object for each request.
  #
  # Options are:
  #
  #   :reraise_exceptions
  #
  #     Whether to re-raise exceptions, or just respond with a standard JSON
  #     500 response.
  #
  #   :from
  #
  #     A string that describes where the request happened. This is useful if,
  #     for example, you want to log which server the request is from. Defaults
  #     to the machine's hostname.
  #
  class JsonLogs

    def initialize(app, options={})
      @app = app
      @options = {
        reraise_exceptions: false
      }.merge(options)
      @options[:from] ||= Socket.gethostname
    end

    def call(env)
      $stdout, previous_stdout = (stdout_buffer = StringIO.new), $stdout
      $stderr, previous_stderr = (stderr_buffer = StringIO.new), $stderr

      begin
        response = @app.call(env)
      rescue Exception => e
        exception = e
      end

      # restore output IOs
      $stferr = previous_stderr; $stdout = previous_stdout

      log = {
        time: Time.now.to_i,
        request: "#{env['REQUEST_METHOD']} #{env['PATH_INFO']}",
        from: @options[:from],
        stdout: stdout_buffer.string,
        stderr: stderr_buffer.string
      }
      if exception
        log[:exception] = {
          message: exception.message,
          backtrace: exception.backtrace
        }
      end
      STDOUT.puts(log.to_json)

      raise exception if exception && @options[:reraise_exceptions]

      response || response_500
    end

    def response_500
      [500, {'Content-Type' => 'application/json'}, [{status: 500, message: 'Something went wrong...'}.to_json]]
    end
  end
end

