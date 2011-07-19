class LinkFetcher
  @queue = :links_queue
  
  def self.perform(link_id)
    link = Link.find(link_id)
    
    begin
      redirects = 5
      found = false
      url = link.url
      while !found or redirects > 0
        uri = URI.parse(url)
        req = Net::HTTP::Get.new(uri.path)
        req["User-Agent"] = link.user_agent.description
        res = Net::HTTP.new(uri.host, uri.port).start do |http|
          http.request(req)
        end
        if res['code'] == '200'
          found = true
        end
        if res['code'] == '302' or res['code'] == '301'
          redirects++
          url = res['location']
        end
      end
      
      link.response_code = res['code'].to_i
      
      if redirects > 5
        link.error = 'Too many redirects'
        link.processed = true
      elsif res['code'] == '200'
        ## Parse headers/body
        link.headers = {}
        res.each_header do |header, value|
          link.headers[header] = value
        end
      
        ## Use pygments to colorize body
        begin
          uri = URI.parse('http://pygments.appspot.com/')
          request = Net::HTTP.post_form(uri, {'lang' => 'html', 'code' => res.body})
          link.body = request.body
        rescue Exception => e
          link.body = res.body
          link.error = "#{e.message}: #{request.body}"
        end
        
        link.processed = true
      else
        link.error = res.body
      end
      link.save
    rescue Exception => e
      link.update_attributes(:error => e.message, :processed => false)
      raise e
    end
  end
end