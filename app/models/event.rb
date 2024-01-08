class Event < ApplicationRecord
  belongs_to :group
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
end
