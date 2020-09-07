require 'json'
require 'optimist'
require_relative 'pretty-printer'


module Rack
  class JsonLogs
    @@opts = Optimist.options do
      opt :stdout,   'Print stdout.',           default: false, short: 'o'
      opt :stderr,   'Print stderr.',           default: false, short: 'e'
      opt :from,     'Print from.',             default: true,  short: 'f'
      opt :trace,    'Print full backtraces.',  default: false, short: 'b'
      opt :duration, 'Print request duration.', default: true,  short: 'd'
      opt :events,   'Print events.',           default: false, short: 'v'
    end

    def self.process(line)
      line_without_prefix = line.sub /^(.+)\sweb\s/, ''
      # line_without_prefix = line.sub /^(.+)\ssidekiq\-worker .+ WARN\:\s/, ''

      begin
        json = JSON.parse(line_without_prefix)
      rescue
        nil # puts "cannot parse '#{line_without_prefix}'"
      end

      json = json['data'] if json && json['data']

      # only pretty print valid objects
      return if json and json['request'] == 'GET /ping'

      if json && json.is_a?(Hash) && json['request']
        Rack::JsonLogs.pretty_print(json, STDOUT, @@opts)
      else
        puts line
      end
    end
  end
end
