class SessionsController < ApplicationController
    def new
    end
    
    def create
        user = User.find_by(email: params[:session][:email].downcase)
        
        if user && user.authenticate(params[:session][:password])
            # access a helper method to create a session with user info
            create_session(user)
            flash[:notice] = "Welcome, #{user.name}"
            redirect_to root_path
        else
            flash.now[:alert] = 'Invalid email/password combintation'
            render :new
        end
    end
    
    def destroy
        # helper methods destroy_session & current_user
        destroy_session(current_user)
        flash[:notice] = "You've been signed out, come back soon!"
        redirect_to root_path
    end
end
