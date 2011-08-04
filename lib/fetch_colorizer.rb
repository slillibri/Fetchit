class FetchColorizer
  attr_accessor :body, :error
  def initialize body
    @body = body
  end
  
  def process
    ## Use pygments to colorize body
    color = error = ''
    
    begin
      uri = URI.parse('http://pygments.appspot.com/')
      request = Net::HTTP.post_form(uri, {'lang' => 'html', 'code' => body})
      @color = request.body
    rescue Exception => e
      @color = res.body
      @error = "#{e.message}: #{request.body}"
    end
  end
end