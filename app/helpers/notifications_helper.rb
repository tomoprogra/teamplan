module NotificationsHelper
    def unchecked_notifications
        @notifications = current_user.passive_notifications.where(checked: false).includes([:visitor])
    end
end
