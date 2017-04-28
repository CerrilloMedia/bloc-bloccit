module UsersHelper
    
    def has_posts_or_comments?(user)
        total = 0
        total += 1 if user.posts.any?
        total += 2 if user.comments.any?
        return total
    end
end
