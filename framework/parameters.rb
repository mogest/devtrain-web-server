require 'json'

class Parameters
  def initialize(request)
    @request = request
    @params = {}
  end

  def parse
    load_form_urlencoded_params(@request.query) if @request.query

    if @request.has_body?
      case @request.content_type
      when 'application/x-www-form-urlencoded'
        load_form_urlencoded_params(@request.body)

      when 'application/json'
        begin
          data = JSON.parse(@request.body)
          if data.is_a?(Hash)
            data.each do |key, value|
              @params[key.to_sym] = value
            end
          end
        rescue JSON::ParserError
        end

      # TODO : support multipart/form-data one day
      end
    end

    self
  end

  def [](key)
    @params[key.to_sym]
  end

  private

  def load_form_urlencoded_params(string)
    queries = string.split("&")
    queries.each do |query|
      key, value = query.split('=', 2)
      @params[urldecode(key).to_sym] = urldecode(value)
    end
  end

  def urldecode(string)
    string
      &.gsub('+', ' ')
      &.gsub(/%[0-9a-f]{2}/) { |x| x[1..2].to_i(16).chr }
  end
end
