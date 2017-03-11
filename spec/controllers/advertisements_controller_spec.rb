require 'rails_helper'

RSpec.describe AdvertisementsController, type: :controller do
  
  let(:my_advert) { Advertisement.create!(title:"Honda civic", body:"Purchase yours today, or else", price: 1000) }

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    
    it "assigns [my_advert] to @advertisements" do
      get :index
      expect(assigns(:advertisements)).to eq([my_advert])
    end
    
  end

  describe "GET show" do
    it "returns http success" do
      get :show, {id: my_advert.id }
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #show view" do
      get :show, {id: my_advert.id }
      expect(response).to render_template :show
    end
    
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    it "increases the number of Post by 1" do
      expect{post :create, advertisement: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 1234.50}}.to change(Advertisement, :count).by(1)
    end
    
    it "assigns a new advertisement to @advertisement" do
      post :create, advertisement: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 1234.50}
      expect(assigns(:advertisement)).to eq Advertisement.last
    end
    
    it "redirets to the new advertisement" do
      post :create, advertisement: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 1234.50}
      expect(response).to redirect_to Advertisement.last
    end
  end

end
