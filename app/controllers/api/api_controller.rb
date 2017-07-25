class API::ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate!

  private

  def authenticate!
    authenticate_or_request_with_http_token do |token, options|
      token == SECRET[:api_key]
    end
  end
end
