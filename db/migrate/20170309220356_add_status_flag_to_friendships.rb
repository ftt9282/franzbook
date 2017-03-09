class AddStatusFlagToFriendships < ActiveRecord::Migration[5.0]
  def change
    add_column :friendships, :status_flag, :integer, default: 0
  end
end
