class LinksController < ApplicationController
  def index
    @links = Link.order('updated_at DESC').page(params[:page])
  end

  def show
    @link = Link.find(params[:id])
    @headers = @link.processed? ? YAML.load(@link.headers) : {}
  end

  def create
    unless RateLimiter.limit(request.remote_ip)
      @ua = UserAgent.find(params[:user_agent])
      @link = Link.new(params[:link].merge(:processed => false, :user_agent => @ua))
      if @link.save
        Resque.enqueue(LinkFetcher, @link.id)
        respond_to do |format|
          format.html { redirect_to links_path }
          format.js do
            @links = Link.order('updated_at DESC').page(params[:page])
            render :index
          end
        end
      end
    else
      flash[:error] = "You have exceeded the rate limit, please try again in a little bit"
      redirect_to root_path
    end
  end

  def raw
    @link = Link.find(params[:link_id])
    @headers = @link.processed ? YAML.load(@link.headers) : {}
  end
end
