require 'rails_helper'
include SessionsHelper

RSpec.describe VotesController, type: :controller do
    let(:my_topic) { create(:topic) }
    let(:my_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:user_post) { create(:post, topic: my_topic, user: other_user ) }
    
    
    let(:my_vote) { Vote.create!(value: 1) }
    
    # youur user creates a topic and other_user creates a post within your topic (as a member), and you will vote on that post.
    
    context "guest" do
        describe "POST up_vote" do
           it "redirects the user to the sign in view" do
              post :up_vote, post_id: user_post.id
              expect(response).to redirect_to(new_session_path)
           end
        end
        
        describe "POST down_vote" do
           it "redirects the user to the sign in view" do
              post :down_vote, post_id: user_post.id
              expect(response).to redirect_to(new_session_path)
           end
        end
    end
    
    context "signed in user" do
        before do
            create_session(my_user)
            request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
        end
        
        describe "POST up_vote" do
            
            it "the users first vote increases number of post votes by one" do
                votes = user_post.votes.count
                post :up_vote, post_id: user_post.id
                expect(user_post.votes.count).to eq(votes + 1)
            end
            
            it "the users second vote does not increase the number of votes" do
                post :up_vote, post_id: user_post.id
                # take a vote count
                votes = user_post.votes.count
                # create a second vote for my_user to same post
                post :up_vote, post_id: user_post.id
                # expect count to be unchanged
                expect(user_post.votes.count).to eq(votes)
            end
            
            it "increases the sum of post votes by one" do
                points = user_post.points
                post :up_vote, post_id: user_post.id
                expect(user_post.points).to eq(points + 1)
            end
            
            # once a vote is cast, there is no 'up_vote' view so we must return immediately to where the vote took place
            it ":back redirects to the posts show page" do
                # returns to topic/id/posts/id/show
                request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
                post :up_vote, post_id: user_post.id
                expect(response).to redirect_to([my_topic, user_post])
            end
            
            it ":back redirects to the posts topic show" do
                # returns to topic/id/show
                request.env["HTTP_REFERER"] = topic_path(my_topic)
                post :up_vote, post_id: user_post.id
                expect(response).to redirect_to(my_topic)
            end
        
        end
        
        describe "POST down_vote" do
            
            it "the users first vote increases number of post votes by one" do
                votes = user_post.votes.count
                post :down_vote, post_id: user_post.id
                expect(user_post.votes.count).to eq(votes + 1)
            end
            
            it "the users second vote does not decrease the number of votes" do
                post :down_vote, post_id: user_post.id
                votes = user_post.votes.count
                post :down_vote, post_id: user_post.id
                expect(user_post.votes.count).to eq(votes)
            end
            
            it "decreases the sum of post votes by one" do
                points = user_post.points
                post :down_vote, post_id: user_post.id
                expect(user_post.points).to eq(points - 1)
                
            end
            
            it ":back redirects to posts show page" do
                request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
                post :down_vote, post_id: user_post.id
                expect(response).to redirect_to([my_topic, user_post])
            end
            
            it ":back redirects to post topic show" do
                request.env["HTTP_REFERER"] = topic_path(my_topic)
                post :down_vote, post_id: user_post.id
                expect(response).to redirect_to(my_topic)
                
            end
            
        end
        
    end
    
end

