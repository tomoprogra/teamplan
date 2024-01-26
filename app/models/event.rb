class Event < ApplicationRecord
  belongs_to :group

  validates :title, presence: true, length: { maximum: 15 }
  validates :description, presence: true, length: { maximum: 200 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :group_id, presence: true
  validate :date_before_start
  # validate :date_before_start

  # def date_before_start
  #   errors.add(:start_time, "は過去の日付を選択できません") if start_time < Date.today
  # end
  def date_before_start
    if start_time && end_time && start_time > end_time
      errors.add(:end_time, "は開始日時よりも後の日時を選択してください")
    end
  end
end
