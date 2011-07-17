class Link < ActiveRecord::Base
  require 'digest/sha2'
  validates_presence_of :url, :on => :create, :message => "can't be blank"
  
  before_save :gen_key
  before_save :clean_url
  belongs_to :user_agent, :class_name => "UserAgent", :foreign_key => "user_agent_id"
  
  private
  
  def clean_url
    uri = URI.parse(self.url)
    unless uri.scheme == 'http' or uri.scheme == 'https'
      if uri.host.nil?
        self.url = "http://" + uri.path
      else
        self.url = "http://" + uri.host
      end
    end
  end
  
  def gen_key
    if self.hash.nil?
      hasher = Digest::SHA2.new
      self.hash = hasher.update(self.url).to_s
    end
  end
end
