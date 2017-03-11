require 'rails_helper'

RSpec.describe Advertisement, type: :model do
    
    let(:advert) {Advertisement.create!(title: "test Advert Title", body: "test Advert body", price: 12345)}
    
    describe "attributes" do
       it "has title, body & price attributes" do
          expect(advert).to have_attributes(title: "test Advert Title", body: "test Advert body", price: 12345)
       end
    end
    
    
end
