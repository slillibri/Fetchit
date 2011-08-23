require 'net/http'

class Fetcher
  attr_accessor :link, :max_redirect, :response_code, :headers, :error, :body
  
  def initialize(link, max_redirect = 5)
    self.link = link
    self.max_redirect = max_redirect
  end
  
  def fetch
    begin
      redirects = 0
      found = false
      uri = URI.parse(@link.url)
      uri.path = '/' if uri.path.empty?

      while !found or redirects < @max_redirect
        req = Net::HTTP::Get.new(uri.path)
        req["User-Agent"] = @link.user_agent.description
        res = Net::HTTP.new(uri.host, uri.port).start do |http|
          http.read_timeout = 30
          http.request(req)
        end
        if res.code == '200'
          break
        end
        if res.code == '302' or res.code == '301'
          redirects = redirects + 1
          uri = URI.parse(res.header['location'])
        end
      end
    
      @response_code = res.code.to_i
      
      if redirects > @max_redirect
        @error = 'Too many redirects'
      elsif res.code == '200'
        ## Parse headers/body
        @headers = {}
        res.each_header do |header, value|
          @headers[header] = value
        end
        @body = res.body
      else
        @error = res.body
      end
    rescue Exception => e
      raise e
    end
  end
end
