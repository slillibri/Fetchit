require File.expand_path('../lib/fetcher', __FILE__)

class LinkFetcher
  @queue = :links_queue
  
  def self.perform(link_id)
    link = Link.find(link_id)
    
    begin
      fetcher = Fetcher.new(link)
      fetcher.fetch

      colors = FetchColorizer.new(fetcher.body)

      link.update_attributes!(:body => colors.body, :response => fetcher.response,
                              :error => fetcher.error, :headers => fetcher.headers, :processed => true )

    rescue Exception => e
      link.update_attributes(:error => e.message, :processed => false)
      raise e
    end
  end
end