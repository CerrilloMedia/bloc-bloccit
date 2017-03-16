class QuestionsController < ApplicationController
    
    def index
        @questions = Question.all
    end
    
    def new
        @question = Question.new
    end
    
    def show
        @question = Question.find(params[:id])
    end
    
    def create
        @question = Question.new
        @question.title = params[:question][:title]
        @question.body = params[:question][:body]
        @question.resolved = params[:question][:resolved]
        
        if @question.save
            flash[:notice] = "Question posted!"
            redirect_to @question
        else
            flash.now[:alert] = "Failed to post. Please try again"
            render :new
        end 
    end
    
    def edit 
        @question = Question.find(params[:id])
    end
    
    def update
        @question = Question.find(params[:id])
        @question.title = params[:question][:title]
        @question.body = params[:question][:body]
        @question.resolved = params[:question][:resolved]
        
        if @question.save
            flash[:notice] = "Question updated succesfully!"
            redirect_to @question
        else
            flash.now[:alert] = "Failed to update. Please try again"
            render :edit
        end 
    end
    
    def destroy
        @question = Question.find(params[:id])
        
        if @question.destroy
            flash[:notice] = "Question deleted succesfully"
            redirect_to questions_path
        else
          flash.now[:alert] = "Error deleting question. Please try again."
          render :show
        end
    end
    
end
