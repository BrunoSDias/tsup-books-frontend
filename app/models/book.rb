class Book
  attr_accessor :id, :title, :summary, :user_id, :auth_token
  attr_reader :error

  def initialize(args = {})
    args = args.with_indifferent_access

    @id = args[:id]
    @title = args[:title]
    @summary = args[:summary]
    @user_id = args[:user_id]
    @auth_token = args[:auth_token]
  end

  def self.all(auth_token:)
    payload = Http.call(endpoint: '/api/v1/books', parameters: {}, headers: {Authorization: auth_token}, method: "get")
    body = payload.parsed_response

    if body.is_a?(Hash) && body["errors"]
      self.error = body
      return false
    end

    books = body.map{|b| Book.new(b)}
    books
  end

  def save
    payload = Http.call(endpoint: '/api/v1/books', parameters: books_params, headers: book_headers, method: "post")
    body = payload.parsed_response
    if body["errors"]
      self.error = body
      return false
    end

    fill_attributes(payload)
  end

  def update
    payload = Http.call(endpoint: "/api/v1/books/#{id}", parameters: books_params, headers: book_headers, method: "patch")
    body = payload.parsed_response
    if body["errors"]
      self.error = body
      return false
    end

    fill_attributes(payload)
  end

  def destroy
    payload = Http.call(endpoint: "/api/v1/books/#{id}", parameters: books_params, headers: book_headers, method: "delete")
    body = payload.parsed_response
    if body["errors"]
      self.error = body
      return false
    end
    
    true
  end

  def error=(obj)
    @error = Error.new(obj)
  end

  private

  def fill_attributes(response)
    self.instance_variables.each do |var|
      self.instance_variable_set(var, response[var.to_s.sub("@", "")])
    end
  end

  def book_headers
    {
      Authorization: auth_token
    }
  end

  def books_params
    {
      book: {
        title: email,
        summary: password
      }
    }
  end
end