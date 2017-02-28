require 'rails_helper'

RSpec.describe Comment, type: :model do
    
    let(:post) { Post.create!(title: "New Post Title", body: "New Post Body") }
    let(:comment) { Comment.create!(body: 'Comment Body', post: post)}
    
    describe "attributes" do
        it "has a body attribute" do
            expect(comment).to have_attributes(body: 'Comment Body', post: post)
        end
    end
       
    describe "associations" do 
        it "belong to post" do
            expect(comment.post.title).to eq(post.title)
        end
    end
end
