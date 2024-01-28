class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.includes(:visitor).checked.page(1).per(5)
      respond_to do |format|
        format.turbo_stream do
            render turbo_stream: [
                turbo_stream.append('notifications', partial: 'notifications/notification', collection: @notifications, as: :notification ),
                turbo_stream.replace('notification_count', partial: 'notifications/notification_count', locals: { notifications: @notifications })
            ]
        end
        format.html
      end
  end
  def destroy
    @notification = current_user.passive_notifications.includes(:visitor).find(params[:id])
    @notification.destroy
    if @notification
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
              turbo_stream.remove(@notification),
              turbo_stream.replace('notification_count', partial: 'notifications/notification_count', locals: { notifications: current_user.notifications })
          ]
        end
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
              turbo_stream.replace('notifications', '')
          ]
        end
      end
    end
  end



  def destroy_all
    @notifications = current_user.passive_notifications.includes(:visitor)
    @notifications.destroy_all
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove('notifications'),
          turbo_stream.replace('notification_count', partial: 'notifications/notification_count', locals: { notifications: current_user.notifications }),
          turbo_stream.prepend('no_notification', partial: 'notifications/no_notification')
        ]
      end
      format.html
    end
  end
end
