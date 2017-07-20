class API::WebhooksController < API::ApiController
  
  def temp
    Record.create!(**record_params)
    head :created
  end

  private

  def record_params
    { temerature: params[:temerature].to_f, recorded_at: DateTime.now }
  end
end
