class User < ApplicationRecord
  mount_uploader :profile_image, ProfileImageUploader
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :chats, dependent: :destroy
  has_many :permits, dependent: :destroy

  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  # ユーザーが所属するグループの一覧
  def belonging_groups
    groups
  end

  # ユーザーが指定したグループに所属しているかどうかをチェックする
  # def belongs_to_group?(group)
  #   return false unless group
  #   groups.exists?(group.id)
  # end

  def events_for_calendar
    group_ids = self.groups.pluck(:id)
    Event.where(group_id: group_ids)
  end

  def events_for_calendar_by_date(selected_date)
    group_ids = self.groups.pluck(:id)
    Event.where(group_id: group_ids)
        .where('(start_time >= ? AND start_time <= ?) OR (end_time >= ? AND end_time <= ?)',
                selected_date.beginning_of_day, selected_date.end_of_day,
                selected_date.beginning_of_day, selected_date.end_of_day)
        .order(:start_time)
  end
end
