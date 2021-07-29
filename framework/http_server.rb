require 'socket'

class HTTPServer
  def initialize(port)
    @server = TCPServer.new(port)
  end

  def run
    loop do
      connection = @server.accept
      Thread.start(connection) do |client|
        HTTPConnection.new(client).run
      end
    end
  end
end
