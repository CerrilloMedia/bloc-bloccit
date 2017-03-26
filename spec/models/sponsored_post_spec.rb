require 'rails_helper'

RSpec.describe SponsoredPost, type: :model do
    
    # Topic attributes
    let(:name) { RandomData.random_sentence }
    let(:description) { RandomData.random_paragraph}
    
    # Sponsored_Post attributes
    let(:title) { RandomData.random_sentence }
    let(:body) { RandomData.random_paragraph }
    let(:price) { (1...100).to_a.sample }
    
    # create Topic
    let(:topic) { Topic.create!(name: name, description: description) }
    
    # create sponsored_post (child) THROUGH topic (parent)
    let(:sponsored_post) { topic.sponsored_posts.create!(title: title, body: body, price: price)}
    
    describe "attributes" do
        it "has title, body & price attributes" do
            expect(sponsored_post).to have_attributes(title: title, body: body, price: price)
        end
    end
end
