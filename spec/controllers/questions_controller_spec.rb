require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    
    let(:my_question) { Question.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_sentence.length.odd?) }
    
    describe "GET index" do
        
        it "returns http success" do
            get :index
            expect(response).to have_http_status(:success)
        end
        
        it "assigns [my_question] to @quesitons" do
            get :index
            expect(assigns(:questions)).to eq([my_question])
        end
    end
    
    describe "GET new" do
       
       it "returns http success" do
           get :new
           expect(response).to have_http_status(:success)
       end
       
       it "renders the #new view" do
           get :new
           expect(response).to render_template(:new)
       end
       
       it "initiates @question" do
           get :new
           expect(assigns(:question)).not_to be_nil 
       end
       
    end
    
    describe "GET show" do
       
       it "returns http success" do
          get :show, {id: my_question.id }
          expect(response).to have_http_status(:success)
       end
       
       it "renders the #show view" do
           get :show, {id: my_question.id}
           expect(response).to render_template :show
       end
       
       it "assigns my_question to @question" do
           get :show, {id: my_question.id }
           expect(assigns(:question)).to eq(my_question)
       end
       
    end
    
    describe "POST create" do
       
        it "increases the number of Questions by 1" do
            expect{post :create, question: {title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_sentence.length.odd? }}.to change(Question, :count).by(1)
        end
        
        it "assigns the new question to @question" do
            post :create, question: { title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_sentence.length.odd? }
            expect(assigns(:question)).to eq Question.last
        end
        
        it "redirects to the new question" do
            post :create, question: { title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: RandomData.random_sentence.length.odd? }
            expect(response).to redirect_to Question.last
        end
        
    end
    
    describe "GET edit" do
        
        it "returns http success" do
           get :edit, {id: my_question.id}
           expect(response).to have_http_status(:success)
           
        end
        
    end
    
    describe "PUT update" do
        
        it "updates post with expected attributes" do
           new_title = RandomData.random_sentence
           new_body = RandomData.random_paragraph
           new_resolved = RandomData.random_sentence.length.even?
           
           put :update, id: my_question.id, question: {title: new_title, body: new_body, resolved: new_resolved }
           
           update_question = assigns(:question)
           #make sure the id doesn't change
           expect(update_question.id).to eq my_question.id
           
           #compare to new_ variables
           expect(update_question.title).to eq new_title
           expect(update_question.body).to eq new_body
           expect(update_question.resolved).to eq new_resolved
           
        end
        
        it "redirects to the udpated question" do
           new_title = RandomData.random_sentence
           new_body = RandomData.random_paragraph
           new_resolved = RandomData.random_sentence.length.even?
           
           put :update, id: my_question.id, question: {title: new_title, body: new_body, resolved: new_resolved }
           
           expect(response).to redirect_to my_question
        end
        
    end
    
    describe "DELETE destroy" do
        
        it "deletes the question" do
           delete :destroy, {id: my_question.id}
           
           count = Question.where(id: my_question.id).size
           expect(count).to eq 0
        end
        
        it "redirect to questions index" do
            delete :destroy, {id: my_question.id}
            
            expect(response).to redirect_to questions_path
        end
        
    end

end
