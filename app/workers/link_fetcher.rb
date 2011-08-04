require File.expand_path("#{Rails.root}/lib/fetcher")
require File.expand_path("#{Rails.root}/lib/fetch_colorizer")

class LinkFetcher
  @queue = :links_queue
  
  def self.perform(link_id)
    link = Link.find(link_id)
    
    begin
      fetcher = Fetcher.new(link)
      fetcher.fetch

      colors = FetchColorizer.new(fetcher.body)

      link.update_attributes!(:body => colors.body, :response_code => fetcher.response_code,
                              :error => fetcher.error, :headers => fetcher.headers, :processed => true )

    rescue Exception => e
      link.update_attributes!(:error => e.message, :processed => false)
      raise e
    end
  end
end