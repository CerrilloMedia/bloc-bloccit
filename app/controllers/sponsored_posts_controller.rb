class SponsoredPostsController < ApplicationController
  
  def show
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @sponsored_post = SponsoredPost.new
  end
  
  def create
    @sponsored_post = SponsoredPost.new
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]
    
    @topic = Topic.find(params[:topic_id])
    @sponsored_post.topic = @topic
    # we don't do @sponsored_post.topic = Topic.find(params[:id]) because we need @topic to be separate for rails resourceful routing
    
    
    if @sponsored_post.save
      flash[:notice] = "Sponsored post was saved successfully"
      redirect_to [@topic, @sponsored_post]
    else
      flash.now[:alert] = "Error creating sponsored post. Please try again."
      render :new
    end
    
  end

  def edit
    @sponsored_post = SponsoredPost.find(params[:id])
  end
  
  def update
    @sponsored_post = SponsoredPost.find(params[:id])
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]
    
    if @sponsored_post.save
      redirect_to [@sponsored_post.topic, @sponsored_post], notice: "Sponsored post was saved successfully"
    else
      flash.now[:alert] = "Error creating sponsored post. Please try again."
      render :new
    end
  end
  
  def destroy
    @sponsored_post = SponsoredPost.find(params[:id])
    
    if @sponsored_post.destroy
      flash[:notice] = "Post \"#{@sponsored_post.title} was deleted successfully"
      redirect_to @sponsored_post.topic
    else
      flash.now[:alert] = "There was an error deleting your post"
      render :show
    end
  end
  
end
