class ApplicationController < ActionController::Base
  before_action :authenticate
  helper_method :current_user

  def authenticate
    return (redirect_to '/sessions/sign_up') unless cookies[:user_auth]

    headers = { Authorization: cookies[:user_auth] }
    response = Http.call(endpoint: 'api/v1/users/by_token', parameters: {}, headers: headers, method: 'get')
    @current_user ||= User.new(response.parsed_response)
    @current_user.auth_token = response.headers["authorization"]
  end
end
