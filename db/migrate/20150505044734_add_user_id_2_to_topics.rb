class AddUserId2ToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :user_id, :integer
  end
end
