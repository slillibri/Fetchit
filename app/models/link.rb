class Link < ActiveRecord::Base
  require 'digest/sha2'
  validates_presence_of :url, :on => :create, :message => "can't be blank"
  
  before_save :gen_key
  belongs_to :user_agent, :class_name => "UserAgent", :foreign_key => "user_agent_id"
  
  private
  
  def gen_key
    if self.hash.nil?
      hasher = Digest::SHA2.new
      self.hash = hasher.update(self.url).to_s
    end
  end
end
