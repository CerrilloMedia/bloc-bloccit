require 'rails_helper'

RSpec.describe SponsoredPostsController, type: :controller do
  
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:my_s_post) { my_topic.sponsored_posts.create!( title: RandomData.random_sentence, body: RandomData.random_paragraph, price: (1..100).to_a.sample ) }

  # GET index is now handled by the Topic controllers topic#show view
  
  describe "GET show" do
    it "returns http success" do
      get :show, topic_id: my_topic.id, id: my_s_post.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_s_post.id
      expect(response).to render_template(:show)
    end
    
    it "assigns my_s_post to @sponsored_post" do
      get :show, topic_id: my_topic.id, id: my_s_post.id
      expect(assigns(:sponsored_post)).to eq(my_s_post)
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
    
    it "instantiates @sponsored_post" do
      get :new, topic_id: my_topic.id
      expect(assigns(:sponsored_post)).not_to be_nil
    end
  end
  
  describe "POST create" do
    # increase by 1
    it "increases the number of Sponsored Posts by 1" do
      expect{ post :create, topic_id: my_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph , price: (1..60).to_a.sample}  }.to change(SponsoredPost, :count).by(1)
    end
    # post to database
    it "assigns the new post to @sponsored_post" do
      post :create, topic_id: my_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph , price: (1..60).to_a.sample}
      expect(assigns(:sponsored_post)).to eq SponsoredPost.last
    end
    # redirect to post
    it "redirect to the new sponsored-post" do
      post :create, topic_id: my_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph , price: (1..60).to_a.sample}
      expect(response).to redirect_to([my_topic, SponsoredPost.last])
    end
  end

  describe "GET edit" do
    it "returns http success" do
      get :edit, topic_id: my_topic.id, id: my_s_post.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #edit view" do
      get :edit, topic_id: my_topic.id, id: my_s_post.id
    end
    
    it "assigns sponsored-post to be updated to @sponsored_post" do
      get :edit, topic_id: my_topic.id, id: my_s_post.id
      instance = assigns(:sponsored_post)
      
      expect(instance.id).to eq my_s_post.id
      expect(instance.title).to eq my_s_post.title
      expect(instance.body).to eq my_s_post.body
      expect(instance.price).to eq my_s_post.price
    end
  end
  
  describe "PUT update" do
    
    it "updates sponsored post with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_price = (1..100).to_a.sample
      
      put :update, topic_id: my_topic.id, id: my_s_post.id, sponsored_post: {title: new_title , body: new_body, price: new_price}
      
      new_post = assigns(:sponsored_post)
      
      expect(new_post.id).to eq my_s_post.id
      expect(new_post.title).to eq new_title
      expect(new_post.body).to eq new_body
      expect(new_post.price).to eq new_price
      
    end
    
    it "redirects to the updated post" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_price = (1..100).to_a.sample
      
      put :update, topic_id: my_topic.id, id: my_s_post.id, sponsored_post: {title: new_title , body: new_body, price: new_price}
      expect(response).to redirect_to([my_topic, my_s_post])
    end
    
  end
  
  describe "DELETE destroy" do
    
    it "deletes the sponsored post" do
      # make sure database count is back to 0
      delete :destroy, topic_id: my_topic.id, id: my_s_post.id
      
      count = SponsoredPost.where(id: my_s_post).size
      expect(count).to eq 0
    end
    
    # make sure to redirect users to the parent topic
    it "redirect to topic show view" do
      delete :destroy, topic_id: my_topic.id, id: my_s_post.id
      expect(response).to redirect_to my_topic
    end
    
  end

end
