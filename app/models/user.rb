class User
  attr_accessor :id, :email, :password, :password_confirmation, :auth_token
  attr_reader :error

  def initialize(args = {})
    return unless args.is_a?(Hash)
    args = args.with_indifferent_access

    @id = args[:id]
    @email = args[:email]
    @password = args[:password]
    @password_confirmation = args[:password_confirmation]
  end

  def save
    payload = Http.call(endpoint: '/api/v1/users', parameters: user_params, headers: {}, method: "post")
    body = payload.parsed_response
    if body["errors"]
      self.error = body
      return false
    end

    fill_attributes(payload)
  end

  def find_by
    payload = Http.call(endpoint: '/api/v1/users', parameters: user_params, headers: {}, method: "get")
    body = payload.parsed_response
    if body["errors"]
      self.error = body
      return false
    end

    fill_attributes(payload)
  end

  def self.authenticate(email:, password:)
    payload = Http.call(endpoint: '/api/v1/users/sign_in', parameters: {user: { email: email, password: password }}, headers: {}, method: "post")
    body = payload.parsed_response
    user = User.new

    if body.is_a?(Array) && body[0]["message"]
      user.error = body
      return user
    end

    user.id = body["id"]
    user.email = body["email"]
    user.auth_token = payload.headers['authorization']
    user
  end

  def error=(obj)
    @error = Error.new(obj)
  end

  private

  def fill_attributes(response)
    self.instance_variables.each do |var|
      self.instance_variable_set(var, response[var.to_s.sub("@", "")])
    end
    self.instance_variable_set(:@auth_token, response.headers["authorization"])
  end

  def user_params
    {
      user: {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    }
  end
end