class TopicsController < ApplicationController
    
    # all views are available to members/admins while guests are only allowed the index/show views
    before_action :require_sign_in, except: [:index, :show]
    
    before_action :authorize_user, except: [:index, :show, :edit, :update]
    
    before_action :authorize_update, only: [:edit, :update]
    
    def index
       @topics = Topic.all
    end
    
    def show
      @topic = Topic.find(params[:id]) 
    end
    
    def new
        @topic = Topic.new
    end
    
    def create
        @topic = Topic.new(topic_params)
        
        if @topic.save
            redirect_to @topic, notice: "Topic was saved successfully."
        else
            flash.now[:alert] = "Error creating topic. Please try again."
            render :new
        end
    end
    
    def edit
        @topic = Topic.find(params[:id])
    end
    
    def update
        @topic = Topic.find(params[:id])
        @topic.assign_attributes(topic_params)
        
        if @topic.save
            redirect_to @topic, notice: "Topic was saved successfully."
        else
            flash.now[:alert] = "Error creating topic. Please try again."
            render :edit
        end
    end
    
    def destroy
        @topic = Topic.find(params[:id])
        
        if @topic.destroy
            flash[:notice] = "\"#{@topic.name}\" was deleted successfully"
            redirect_to action: :index
        else
            flash.now[:alert] = "There was an error deleting the topic"
            render :show
        end
    end
    
    
    private
    
    def topic_params
       params.require(:topic).permit(:name, :description, :public)
    end
    
    def authorize_user
        unless current_user.admin?
            flash[:alert] = "You must be an Admin to do that."
            redirect_to topics_path
        end
    end
    
    def authorize_update
        unless current_user.moderator? || current_user.admin?
            flash[:alert] = "You do not have proper authorization for that."
            redirect_to topics_path
        end
    end
    
end
