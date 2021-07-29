class FailsController
  attr_reader :request, :params, :response

  def initialize(request)
    @request = request
    @params = Parameters.new(@request).parse
  end

  private

  def render(body, type:, status: 200, headers: {})
    if type.include?("/")
      headers['content-type'] = type

      @response = HTTPResponse.new(status, "", version: @request.version, headers: headers, body: body)
    else
      raise "Unknown type"
    end
  end
end
