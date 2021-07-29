class Parameters
  def initialize(request)
    @request = request
    @params = {}
  end

  def parse
    if @request.query
      queries = @request.query.split("&")
      queries.each do |query|
        key, value = query.split('=', 2)
        @params[key.to_sym] = value
      end
    end

    # TODO : bring in parameters from body of request

    self
  end

  def [](key)
    @params[key.to_sym]
  end
end
