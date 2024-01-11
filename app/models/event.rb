class Event < ApplicationRecord
  belongs_to :group

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :group_id, presence: true
  validate :date_before_start

  def date_before_start
    errors.add(:start_time, "は過去の日付を選択できません") if start_time < Date.today
  end
end
