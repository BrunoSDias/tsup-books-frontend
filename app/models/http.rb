class Http
  include HTTParty
  BASE_URI = "http://localhost:3000".freeze

  attr_accessor :endpoint, :parameters, :headers, :method

  def initialize(endpoint:, parameters: {}, headers: {}, method: 'get')
    @endpoint = endpoint
    @parameters = parameters
    @headers = headers
    @method = method
  end

  def self.call(...)
    new(...).call
  end

  def call
    self.class.send(method, "#{BASE_URI}/#{endpoint}", body: parameters, headers: headers)
  end
end