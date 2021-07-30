class HTTPResponse
  attr_reader :status_code, :status_text, :version, :headers, :body

  TEXT_FOR_STATUS_CODES = {
    200 => 'OK',
    301 => 'Permanently Redirected',
    302 => 'Temporarily Redirected',
    400 => 'Bad Request',
    404 => 'File Not Found',
    405 => 'Method Not Allowed',
    411 => 'Length Required',
    500 => 'Server Error',
  }

  def initialize(status_code, version: '1.0', headers: {}, body: nil)
    @status_code = status_code
    @version = version
    @headers = headers
    self.body = body
  end

  def status_text
    TEXT_FOR_STATUS_CODES.fetch(@status_code, @status_code)
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
