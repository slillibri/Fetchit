require 'net/http'

class FetchColorizer
  attr_accessor :body, :error, :color
  def initialize body
    @body = body
  end
  
  def process
    ## Use pygments to colorize body
    begin
      uri = URI.parse('http://pygments.appspot.com/')
      request = Net::HTTP.post_form(uri, {'lang' => 'html', 'code' => @body})
      @color = request.body
    rescue Exception => e
      @color = @body
      @error = "#{e.message}"
    end
  end
end