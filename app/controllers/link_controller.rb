class LinkController < ApplicationController
  def index
    @links = Link.order('updated_at DESC').page
  end

  def show
    @link = Link.find(params[:id])
    @headers = @link.processed? ? YAML.load(@link.headers) : {}
  end

  def create
    @ua = UserAgent.find(params[:user_agent])
    @link = Link.new(params[:link].merge(:processed => false, :user_agent => @ua))
    if @link.save
      Resque.enqueue(LinkFetcher, @link.id)
      redirect_to link_path(@link)
    end    
  end
end
