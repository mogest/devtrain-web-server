class HTTPResponse
  attr_reader :status_code, :status_text, :version, :headers, :body

  def initialize(status_code, status_text, version: '1.0', headers: {}, body: nil)
    @status_code = status_code
    @status_text = status_text
    @version = version
    @headers = headers
    self.body = body
  end

  def body=(value)
    if value
      @headers['content-length'] = value.length
      @body = value
    else
      @headers.delete('content-length')
      @body = nil
    end
  end
end
