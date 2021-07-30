class HTTPRequest
  ParseError = Class.new(StandardError)
  InvalidStatusLineError = Class.new(ParseError)
  InvalidMethodError = Class.new(ParseError)

  VALID_METHODS = %w(GET POST PUT PATCH DELETE HEAD)
  METHODS_WITH_BODY = %w(POST PUT PATCH DELETE)

  attr_reader :method, :fullpath, :path, :query, :version, :headers
  attr_accessor :body

  def initialize(method, fullpath, version)
    raise InvalidMethod unless VALID_METHODS.include?(method)

    @method = method
    @fullpath = fullpath
    @path, @query = fullpath.split("?", 2)
    @version = version
    @headers = {}
  end

  def has_body?
    METHODS_WITH_BODY.include?(@method)
  end

  def content_type
    @headers['content-type']&.split(";", 2)&.first
  end

  def self.from_status_line(line)
    matches = line.strip.match(/^([A-Z]+) ([^ ]+) HTTP\/(1\.[01])/)

    raise InvalidStatusLineError unless matches

    new(
      matches[1],
      matches[2],
      matches[3]
    )
  end
end
