require 'random_data'

#Create Posts
50.times do
    Post.create!(
        title:  RandomData.random_sentence,
        body:   RandomData.random_paragraph
    )
end

posts = Post.all
100.times do
   Comment.create!(
       post: posts.sample,
       body: RandomData.random_paragraph
   )
end

#Create Questions
60.times do
    Question.create!(
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph,
        resolved: RandomData.random_sentence.length.odd?
    )
end

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Question.count} Questions created"


