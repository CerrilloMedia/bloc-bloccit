require 'random_data'

#Create Posts
50.times do
    Post.create!(
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph
    )
end

Post.find_or_create_by!(title: "unique post-title", body: "unique post-body")

posts = Post.all

100.times do
    Comment.create!(
        post: posts.sample,
        body: RandomData.random_paragraph
   )
end

Comment.find_or_create_by!(post: posts.find_by(title: "unique post-title"), body: "unique comment-body")

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"