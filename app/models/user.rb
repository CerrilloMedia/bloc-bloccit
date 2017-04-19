class User < ActiveRecord::Base
    has_many :posts, dependent: :destroy #make sure to add [belongs_to :user] to the posts model.
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    
    before_save { self.email = email.downcase if email.present? }
    
    #default to member
    before_save { self.role ||= :member }
    
    validates :name, length: { minimum: 1, maximum: 100 }, presence: true
    
    validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
    validates :password, length: { minimum: 6 }, allow_blank: true
    
    validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }
                
    has_secure_password
    
    enum role: [:member, :admin, :moderator]
end
