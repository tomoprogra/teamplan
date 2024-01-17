class User < ApplicationRecord
  mount_uploader :profile_image, ProfileImageUploader
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         invite_for: 24.hours

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :chats, dependent: :destroy


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
end
