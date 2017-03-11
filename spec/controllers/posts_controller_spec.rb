require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  # adding type :controller allows us to simulate controller actions such as HTTP requests.
  
  let(:my_post) { Post.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    
    it "assigns [my_post] to @posts" do
      get :index
      expect(assigns(:posts)).to eq([my_post])
    end
    
  end
  
  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end
    
    it "instantiates @post" do
      get :new
      # assigns() gives us access to the @post variable, assigning it to :post
      expect(assigns(:post)).not_to be_nil
    end
    
  end
  
  describe "POST create" do # POST(verb) for HTTP requests, not the name Post from database table
    it "increases the number of Post by 1" do
      # post :create writes to the database
      expect{post :create, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Post, :count).by(1)
    end
    
    it "assigns the new post to @post" do
      post :create, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      # expect newly created post is equal to the last one in the Post table in db
      expect(assigns(:post)).to eq Post.last
    end
    
    it "redirects to the new post" do
      post :create, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      # expect to redirect to most recent posts view
      expect(response).to redirect_to Post.last
    end
  end
  
  describe "GET show" do
    it "returns http success" do
      get :show, {id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #show view" do
      get :show, {id: my_post.id}
      expect(response).to render_template :show
    end
    
    it "assigns my_post to @post" do
      get :show, {id: my_post.id }
      expect(assigns(:post)).to eq(my_post)
    end
  end
    
end
