class CalculatorController < FailsController
  def run
    if params[:a].nil? || params[:b].nil?
      result = {error: "You need to specify 'a' and 'b' parameters"}
      render result.to_json, status: 400, type: 'application/json'

    else
      sum = params[:a] + params[:b]
      result = {sum: sum}

      render result.to_json, type: 'application/json'
    end
  end
end
