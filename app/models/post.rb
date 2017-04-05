class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user #make sure to add [has_many :posts] to the user model.
    has_many :comments, dependent: :destroy 
    
    validates :title, length: { minimum: 5 }, presence: true
    validates :body, length: { minimum: 20 }, presence: true
    
    # due to belongs_to and having a user_id & topic_id in the Post table we need to make sure
    # a post has both a topic and author(user)
    validates :topic, presence: true
    validates :user, presence: true
    
    # scoping posts allows us to retrieve and order posts by their created_at date in descending order
    default_scope { order('created_at DESC') }
    
end