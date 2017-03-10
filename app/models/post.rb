class Post < ActiveRecord::Base
    has_many :comments
    
    def check_post_for_spam
        # check if it's id is either the 1st or 5th and alter it's title with "SPAM"
        if (self.id % 5 === 0)
            self.title = "SPAM"
            puts "SPAM FOUND: post #" + self.id.to_s + " has been flagged."
        end
        #save to DB
        self.save
    end
    
    
    
end