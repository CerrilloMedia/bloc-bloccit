require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    
    let(:new_user_attributes) do
       {
           name: "BlocHead",
           email: "blochead@bloc.io",
           password: "blochead",
           password_confirmation: "blochead"
       } 
    end
    
    describe "GET new" do
       it "returns http success" do
           get :new
           expect(response).to have_http_status(:success)
       end
       
       it "istantiates a new user" do
           get :new
           expect(assigns(:user)).to_not be_nil
       end
       
    end
    
    describe "POST create" do
       
       it "returns an http redirect" do
           post :create, user: new_user_attributes
           expect(response).to have_http_status(:redirect)
       end
       
       it "creates a new user" do
           expect{ post :create, user: new_user_attributes }.to change(User, :count).by(1)
       end
       
       it "sets user name propoerly" do
           post :create, user: new_user_attributes
           expect(assigns(:user).name).to eq new_user_attributes[:name]
       end
       
       it "sets user email properly" do
           post :create, user: new_user_attributes
           expect(assigns(:user).email).to eq new_user_attributes[:email]
       end
       
       it "sets user password properly" do
           post :create, user: new_user_attributes
           expect(assigns(:user).password).to eq new_user_attributes[:password]
       end
       
       it "sets user password_confirmation properly" do
           post :create, user: new_user_attributes
           expect(assigns(:user).password_confirmation).to eq new_user_attributes[:password_confirmation]
       end
       
       it "logs the user in after sign up" do
           post :create, user: new_user_attributes
           expect(session[:user_id]).to eq assigns(:user).id
       end
        
    end
    
    describe "not signed in" do
        
       let(:factory_user) { create(:user) }
        
       before do
            post :create, { user: new_user_attributes }
       end
       
       
       it "returns http success" do
          get :new, {id: factory_user.id }
          expect(response).to have_http_status(:success)
       end
       
       it "renders the #show view" do
          get :show, {id: factory_user.id }
          expect(response).to render_template :show
       end
       
       it "assigns factory_user to @user" do
           get :show, {id: factory_user.id}
           expect(assigns(:user)).to eq(factory_user)
       end 
    end
    
    describe "favorited post" do
         
       let(:factory_user) { create(:user) }
        
       before do
            post :create, { user: new_user_attributes }
       end
       
       it "it displays the total votes and comments for the favorited post" do
           
            author = assigns(:user)
            post = FactoryGirl.create :post, user: author
            comment = FactoryGirl.create :comment, post: post
            vote = FactoryGirl.create :vote, post: post
            favorite = Favorite.create!(post: post, user: factory_user)
            author = User.find(post.user_id)
           
            get :show, { id: factory_user.id }
            
            favorited_post = assigns(:user).favorites.first
            comments = Post.find(favorited_post.post_id).comments.count
            votes = Post.find(favorited_post.post_id).votes.count
            
            # The users favorited post comment-total
            expect(comments).to eq(1)
            
            # The users favorited post vote-total
            expect(votes).to eq(1)
            
            # 
            # not sure how to go about matching/verifying gravatar_url's in the view
       end
       
    end
end
