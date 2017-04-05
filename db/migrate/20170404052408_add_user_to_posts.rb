class AddUserToPosts < ActiveRecord::Migration
  
  # adding a user_id column to a posts table with: "rails g migration AddUserToPosts user_id:integer:index"
  # the foreign_key (user_id) will allow for a user to have many posts and a post belong to a user
  # NOTE: make sure to add [belongs_to :user] in the post model and [has_many :posts] to the user model
  def change
    add_column :posts, :user_id, :integer
    add_index :posts, :user_id
  end
end
