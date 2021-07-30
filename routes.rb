Router.draw do |r|
  get "/", HomeController, :index
  post "/calculator", CalculatorController, :run
end
