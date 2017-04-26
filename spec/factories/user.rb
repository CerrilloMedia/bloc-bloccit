FactoryGirl.define do
    
    pw = RandomData.random_sentence
    
    factory :user do #declare the name of the factory.
       name RandomData.random_name
       
       sequence(:email) {|n| "user#{n}@factory.com" } #generate a sequence of :email formatted values
       password pw
       password_confirmation pw
       role :member
    end
    
end