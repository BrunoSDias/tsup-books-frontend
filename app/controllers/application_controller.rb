class ApplicationController < ActionController::Base
  before_action :authenticate
  helper_method :current_user

  def authenticate
    return (redirect_to '/sessions/signup') unless cookies[:user_auth]

    headers = { Authorization: cookies[:user_auth] }
    response = Http.call(endpoint: 'api/v1/users/by_token', parameters: {}, headers: headers, method: 'get')

    if response.code != 200
      cookies[:user_auth] = nil
      redirect_to '/sessions/signin'
      return
    end

    @current_user ||= User.new(response.parsed_response)
    @current_user.auth_token = response.headers["authorization"]
  end
end
