class HTTPConnection
  LengthRequiredError = Class.new(StandardError)

  def initialize(client)
    @client = client
  end

  def run
    response = receive_request_and_generate_response
    send_response(response)
  end

  def receive_request_and_generate_response
    status_line = @client.gets

    @request = HTTPRequest.from_status_line(status_line)

    receive_headers
    receive_body if @request.has_body?

    Router.new(@request).run

  rescue LengthRequiredError
    HTTPResponse.new(411, 'Length Required')
  rescue HTTPRequest::InvalidMethodError
    HTTPResponse.new(405, 'Method Not Allowed')
  rescue HTTPRequest::ParseError
    HTTPResponse.new(400, 'Bad Request')
  rescue => e
    HTTPResponse.new(
      500, 'Server Error',
      headers: {"content-type": "text/plain"},
      body: "#{e.class.name}\n#{e.message}\n\n#{e.backtrace.join("\n")}"
    )
  end

  def receive_headers
    while line = @client.gets&.strip
      break if line == ''

      key, value = line.split(/:\s*/, 2)

      @request.headers[key.downcase] = value
    end
  end

  def receive_body
    length = begin
               Integer(@request.headers['content-length'])
             rescue ArgumentError
             end

    raise LengthRequiredError unless length

    @request.body = @client.read(length)
  end

  def send_response(response)
    @client.puts "HTTP/#{response.version} #{response.status_code} #{response.status_text}"

    response.headers.each do |key, value|
      @client.puts "#{key}: #{value}"
    end

    @client.puts
    @client.write response.body
    @client.close
  end
end
