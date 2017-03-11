class PostsController < ApplicationController
  
  def index
    @posts = Post.all
  end

  def show
      @post = Post.find(params[:id])
  end

  def new
    # the new.html view needs this info when setting up the form prior to sending it to the create method which posts it to the DB
    @post = Post.new
  end
  
  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    
    if @post.save
      flash[:notice] = "Post was saved"
      redirect_to @post
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
  end
  
end
