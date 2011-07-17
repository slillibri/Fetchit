class LinkFetcher
  @queue = :links_queue
  
  def self.perform(link_id)
    link = Link.find(link_id)
    
    begin
      ## Fetch link
      result = HTTParty.get(link.url, {:user_agent => link.user_agent.name})
      ## Parse headers/body
      link.headers = result.headers.to_hash
      
      ## Use pygments to colorize body
      uri = URI.parse('http://pygments.appspot.com/')
      request = Net::HTTP.post_form(uri, {'lang' => 'html', 'code' => result.body})
      link.body = request.body
      
      link.processed = true
      ## Save
      link.save
      
    rescue Exception => e
      raise e
    end
  end
end