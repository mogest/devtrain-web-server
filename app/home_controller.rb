class HomeController < FailsController
  def index
    name = params[:name]

    render "Hello, #{name}!", type: 'text/plain'
  end
end
