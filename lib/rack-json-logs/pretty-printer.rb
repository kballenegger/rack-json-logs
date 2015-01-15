require 'colorize'
require 'stringio'

module Rack
  class JsonLogs

    def self.pretty_print(json, print_to = STDOUT, opts = {})

      opts = {
        stdout:   false,
        stderr:   false,
        from:     true,
        trace:    false,
        duration: true,
        events:   false,
      }.merge(opts)

      out = StringIO.new

      status_color = case json['status']
                     when 200...300; :green
                     when 300...600; :red
                     else :cyan; end


      resp = 'Response: '
      resp << "#{json['status']} " if json['status']
      if opts[:duration] && json['duration']
        resp << "(#{(json['duration']*1000).round}ms) "
      end

      out.puts '     * * *'
      out.puts
      out.puts "Request: #{json['request']}".cyan
      out.puts resp.send(status_color)
      out.puts "From: #{json['from']}".cyan if opts[:from] && json['from']
      out.puts "At: #{Time.at(json['time']).strftime('%b %-e %Y, %-l:%M%P')}"
      out.puts

      %w{stdout stderr}.each do |b|
        next unless opts[b.to_sym]
        color = b == 'stdout' ? :green : :yellow
        log = json[b] || ''
        if log == '' || log == "\n"
          out.puts "No #{b}.".send(color)
        else
          out.puts "#{b}:".cyan
          out.puts log.send(color)
        end
        # Typically log statements start end with a \n, so skiping puts here.
      end

      if opts[:events] && json['events'] && !json['events'].empty?
        out.puts 'Events:'.cyan
        out.puts
        json['events'].each do |e|
          out.puts "Event: #{e['type']}"
          out.puts "At: #{(e['time']*1000).round}ms"
          out.puts "Value: #{e['value'].to_json}"
          out.puts
        end
      end

      if json['exception']
        out.puts "Exception: #{json['exception']['message']}".red
        if opts[:trace]
          out.puts json['exception']['backtrace'].map {|e| "  #{e}"}.join("\n").blue
        end
        out.puts
      end

      print_to.print(out.string)

    end
  end
end
