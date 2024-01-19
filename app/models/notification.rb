class Notification < ApplicationRecord
    default_scope -> { order(created_at: :desc) }
    belongs_to :group, optional: true 
    belongs_to :chat, optional: true
    belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
    belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

    def self_chat_notification?
        # 自分が送信したチャットに対する通知かどうかを判定するメソッド
        action == 'chat' && visitor_id == visited_id
    end
end
