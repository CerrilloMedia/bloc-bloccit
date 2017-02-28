require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  let(:question) { Question.create!( title: "New Question Title", body: "New Question Body", resolved: true ) }
  let(:answer) { Answer.create!( body: "New Answer body", question: question ) }
  
  describe "attributes" do
    it "has body and question attributes" do
      expect(answer).to have_attributes( body: "New Answer body", question: question)
    end
  end
   
  describe "associations" do
    it "belong to question" do
      expect(answer.question.title).to eq (question.title)
    end
  end
end
