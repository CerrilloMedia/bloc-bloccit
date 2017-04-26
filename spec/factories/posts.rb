FactoryGirl.define do
    factory :post do
       title RandomData.random_sentence
       body RandomData.random_paragraph
       topic
       user
    end
end