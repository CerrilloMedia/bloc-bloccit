require 'rails_helper'

# add SessionsHelper to gain access to the create_session(user) method
include SessionsHelper

RSpec.describe PostsController, type: :controller do
  # adding type :controller allows us to simulate controller actions such as HTTP requests.
  
  # adding a user to Posts
  let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }
  let(:other_user) { User.create!(name: "Other Bloccit User", email: "other_user@bloccit.com", password: "goodbyeworld") }
  
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  
  let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }
  let(:other_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: other_user) }
  
  context "guest user" do
    
    describe "GET show" do
      
      it "returns http success" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end
      
      it "renders the #show view" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :show
      end
      
      it "assigns my_post to @post" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(assigns(:post)).to eq(my_post)
      end
      
    end
      
    describe "GET new" do
      # redirect a guest user to log-in page(a.k.a create a new session)
      it "returns http redirect" do
        get :new, topic_id: my_topic.id
        expect(response).to redirect_to(new_session_path)
      end
      
    end
    
    describe "POST create" do
      
      it "returns http redirect" do
        post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence, body: RandomData.random_paragraph }
        expect(response).to redirect_to(new_session_path)
      end
      
    end
    
    describe "PUT update" do
      it "returns http redirect" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body}
        expect(response).to redirect_to(new_session_path)
      end
    end
    
    describe "DELETE destroy" do
      
      it "returns http redirect" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:redirect)
      end
      
    end
    
  end
  
  context "signed-in user" do
    
    before do
      my_user.member!
      my_user.member?
      create_session(my_user)
    end
    
    describe "GET show" do
      
      it "returns http success" do
        # ACTION      # reference the parent topic & post id
        get :show,    topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end
      
      it "renders the #show view" do
        # ACTION      # reference the parent topic & post id
        get :show,    topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :show
      end
      
      it "assigns my_post to @post" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(assigns(:post)).to eq(my_post)
      end
      
    end
    
    describe "GET new" do
      it "returns http success" do
        get :new, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end
      
      it "renders the #new view" do
        get :new, topic_id: my_topic.id
        expect(response).to render_template :new
      end
      
      it "instantiates @post" do
        get :new, topic_id: my_topic.id
        expect(assigns(:post)).not_to be_nil
      end
      
    end
    
    describe "POST create" do
    
      it "increases the number of Post by 1" do
        expect{ post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }.to change(Post, :count).by(1)
      end
      
      it "assigns the new post to @post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        # expect newly created post is equal to the last one in the Post table in db
        expect(assigns(:post)).to eq Post.last
      end
      
      it "redirects to the new post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        # expect to redirect to most recent posts view
        expect(response).to redirect_to [my_topic, Post.last]
      end
      
    end
    
    
    describe "GET edit" do
      
      it "returns http success" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end
      
      it "renders the #edit view" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :edit
      end
      
      it "assigns post to be updated to @post" do
        get :edit, topic_id: my_topic.id, id: my_post.id # <- params hash from it's "view"
        post_instance = assigns(:post)
        
        expect(post_instance.id).to eq my_post.id
        expect(post_instance.title).to eq my_post.title
        expect(post_instance.body).to eq my_post.body
      end
      
      it "is not authorized to edit another users post" do
        get :edit, topic_id: my_topic.id, id: other_post.id
        expect(response).to redirect_to topic_post_url
      end
      
    end
    
    describe "PUT update" do
      
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence.concat("_random")
        new_body = RandomData.random_paragraph.concat("_random")
        
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body }
        
        update_post = assigns(:post)
        expect(update_post.id).to eq my_post.id
        expect(update_post.title).to eq new_title
        expect(update_post.body).to eq new_body
      end
      
      it "redirects to the updated post" do
        new_title = RandomData.random_sentence.concat("_random")
        new_body = RandomData.random_paragraph.concat("_random")
        
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body } #<--- passing :id and :post as part of params
        # Should redirect to my_post page for the recently updated post.
        expect(response).to redirect_to [my_topic, my_post]
        
      end
      
    end
    
    describe "DELETE destroy" do
    
      it "deletes the post" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        
        count = Post.where({id: my_post.id}).size
        expect(count).to eq 0
      end
      
      it "redirect to posts index" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        # instead of redirecting to the posts/index, we now go to the parent topic/show path
        expect(response).to redirect_to my_topic
      end
    end
    
  end
  
  context "moderator user" do
    
    before do
      my_user.moderator!
      other_user.member!
      create_session(my_user)
    end
    
    describe "GET new" do
      
      it "returns http success" do
        get :new, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end
      
      it "renders the #new view" do
        get :new, topic_id: my_topic.id
        expect(response).to render_template :new
      end
      
      it "instantiates @post" do
        get :new, topic_id: my_topic.id
        expect(assigns(:post)).not_to be_nil
      end
    end
    
    describe "POST create" do
      
      it "increases Post count by 1" do
        expect{ post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }.to change(Post, :count).by(1)
      end
      
      it "assigns the new post to @post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        # expect newly created post is equal to the last one in the Post table in db
        expect(assigns(:post)).to eq Post.last
      end
      
      it "redirects to the new post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        # expect to redirect to most recent posts view
        expect(response).to redirect_to [my_topic, Post.last]
      end
      
      
    end
    
    describe "GET edit" do
      # expect my_user to gain access to the edit view for other_post
      it "edits another users post" do
        get :edit, topic_id: my_topic.id, id: other_post.id
        expect(response).to have_http_status(:success)
      end
      
    end
    
    describe "PUT update" do
      
      it "can update another users posts" do
        new_title = "New title from moderator"
        new_body = "New body form moderator"
        
        put :update, topic_id: my_topic.id, id: other_post.id, post: {title: new_title, body: new_body }
        updated_post = assigns(:post)
        
        expect(updated_post.title).to eq new_title
        expect(updated_post.body).to eq new_body
      end
      
    end
    
    describe "DELETE destroy" do
      
      it "returns http redirect" do
        delete :destroy, topic_id: my_topic.id, id: other_post.id
        expect(response).to have_http_status(:redirect)
      end
      
    end
    
  end
    
end
