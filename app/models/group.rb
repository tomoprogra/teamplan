class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :events, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :title, presence: true
end
