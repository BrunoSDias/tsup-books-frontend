class Error
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def full_message
    content.to_s
  end
end