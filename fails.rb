require_relative 'framework/fails_controller.rb'
require_relative 'framework/http_connection'
require_relative 'framework/http_request'
require_relative 'framework/http_response'
require_relative 'framework/http_server'
require_relative 'framework/parameters'
require_relative 'framework/router'


Dir["app/*.rb"].each do |file|
  require_relative file
end

require_relative 'routes'

HTTPServer.new(8080).run
