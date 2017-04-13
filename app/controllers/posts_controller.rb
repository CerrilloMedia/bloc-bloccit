class PostsController < ApplicationController
  
  before_action :require_sign_in, except: :show
  
  before_action :authorize_delete, only: :destroy
  
  before_action :authorize_edit, only: :edit

  def show
      @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end
  
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user
    
    if @post.save
      flash[:notice] = "Post was saved"
      redirect_to [@topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  
  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)
    
    if @post.save
      flash[:notice] = "Post was succesfully updated"
      # note: rails has the ability to generate a route from array 
      # the following would create /topics/topic_id/posts/post_id
      redirect_to [@post.topic, @post]
    else
      flash.now[:alert] = "There was an error updating the post. Please try again."
      render :edit
    end
    
  end
  
  def destroy
    @post = Post.find(params[:id])
    
    if @post.destroy
      flash[:notice] = "post \"#{@post.title}\" was deleted successfully."
      redirect_to @post.topic
    else
      flash.now[:alert] = "error deleting post. Please try again"
      render :show
    end
    
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :body)
  end
  
  def authorize_delete
    # POST MUST EXIST TO BE DELETED
    post = Post.find(params[:id])
    
    unless current_user == post.user || current_user.admin?
      flash[:alert] = "You are not the author or admin to do that."
      redirect_to [post.topic, post]
    end
  end
  
  def authorize_edit
    # POST MUST EXIST TO BE EDITED
    post = Post.find(params[:id])
    
    unless current_user == post.user || current_user.admin? || current_user.moderator?
      flash[:alert] = "As a #{current_user.role}, you are not the authorized for such a request."
      redirect_to [post.topic, post]
    end
  end
  
end