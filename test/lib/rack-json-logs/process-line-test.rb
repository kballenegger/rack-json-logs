require './lib/rack-json-logs/process-line'

File.readlines('sample-kubectl.log').each do |line|
  Rack::JsonLogs.process(line)
end
