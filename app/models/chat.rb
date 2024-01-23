class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :notifications, dependent: :destroy
  broadcasts_to :group
  validates :body, presence: true
  validates :user, presence: true
end
