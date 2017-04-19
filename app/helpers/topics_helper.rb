module TopicsHelper
    
    def user_is_authorized_for_topics?
       current_user && ( current_user.admin? || current_user.moderator? )
    end
    
    def user_has_voted?(post_id)
       current_user.votes.find_by(post_id: post_id)
    end
    
end
