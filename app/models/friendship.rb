class Friendship < ApplicationRecord
  belongs_to :active_user, class_name: "User"
  belongs_to :passive_user, class_name: "User"
end