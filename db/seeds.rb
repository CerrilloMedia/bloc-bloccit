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

puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"

# Create Advertisements
25.times do 
   Advertisement.create!(
       title: RandomData.random_sentence,
       body: RandomData.random_paragraph,
       price: RandomData.random_paragraph.length * 31.2
       ) 
end

puts "#{Advertisement.count} advertisements created"

puts "Seed finished"

