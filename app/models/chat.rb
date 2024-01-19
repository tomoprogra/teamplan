class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :notifications, dependent: :destroy

  validates :body, presence: true

  def create_notification_chat!(current_user, chat_id)
    # グループメンバー全員を検索
    group_users.each do |temp_id|
      save_notification_chat!(current_user, chat_id, temp_id['user_id'])
    end
  end

  def save_notification_chat!(current_user, chat_id, visited_id)
    # グループチャットは複数人が何回もコメントすることが考えられるため、複数回通知する
    notification = current_user.active_notifications.new(
      group_id: id,
      chat_id: chat_id,
      visited_id: visited_id,
      action: 'chat'
    )
    # 自分へのグループチャットに対しての場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
