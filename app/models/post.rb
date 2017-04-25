class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user #make sure to add [has_many :posts] to the user model.
    has_many :comments, dependent: :destroy 
    has_many :votes, dependent: :destroy
    has_many :favorites, dependent: :destroy
    
    after_create :auto_favorite_own_post
    
    validates :title, length: { minimum: 5 }, presence: true
    validates :body, length: { minimum: 20 }, presence: true
    
    # due to belongs_to and having a user_id & topic_id in the Post table we need to make sure
    # a post has both a topic and author(user)
    validates :topic, presence: true
    validates :user, presence: true
    
    # scoping posts allows us to retrieve and order posts by their created_at date in descending order
    default_scope { order('rank DESC') } # <-- update our default scope to filter by post rank as opposed to created_at.
    
    def up_votes
        # SQL query for any vote which is a value of 1
        votes.where(value: 1).count
    end
    
    def down_votes
        # SQL query for any vote which is a value of -1
        votes.where(value: -1).count
    end
    
    def points
        # utilize ActiveRecord #sum method
        votes.sum(:value)
    end

    def update_rank
       age_in_days = (created_at - Time.new(1970,1,1)) / 1.days.seconds
       new_rank = points + age_in_days
       update_attribute(:rank, new_rank)
    end
    
    private
    
    def auto_favorite_own_post
        # User.find(user_id).favorites.create(post: self)
        Favorite.create(post: self, user: self.user)
        FavoriteMailer.new_post(self).deliver_now
    end
    
end