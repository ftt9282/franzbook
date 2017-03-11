class Friendship < ApplicationRecord
  belongs_to :active_user, class_name: "User"
  belongs_to :passive_user, class_name: "User"

  def accept_friend_request
    self.update(status_flag: 1)
  end
end