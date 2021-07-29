class Router
  Route = Struct.new(:method, :path, :controller, :action) do
    def run(request)
      instance = controller.new(request)
      instance.send(action)
      instance
    end
  end

  class Table
    attr_reader :routes

    def initialize
      @routes = []
    end

    def method_missing(name, *args)
      @routes << Route.new(name.to_s, *args)
    end
  end

  @@table = Table.new

  def initialize(request)
    @request = request
  end

  def self.draw(&block)
    @@table.instance_eval(&block)
  end
  
  def run
    route = find_route

    if route
      controller = route.run(@request)

      if controller.response
        controller.response
      else
        HTTPResponse.new(500, "Server error", "Controller did not call 'render'")
      end
    else
      HTTPResponse.new(404, 'File Not Found', body: 'File not found')
    end
  end

  def find_route
    @@table.routes.detect do |route|
      route.path == @request.path && route.method.upcase == @request.method
    end
  end
end
