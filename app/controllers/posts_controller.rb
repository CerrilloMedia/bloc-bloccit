require 'time'

class PostsController < ApplicationController
  
  def index
    @posts = Post.all
  end

  def show
    
  end

  def new
    
    Post.all.each do | post |
      # when creating a new post the individual post should be sent to get checked before being added to the DB.
      # mimic passing a post to check for spam
      post.check_post_for_spam
    end
  end

  def edit
    
  end
end
