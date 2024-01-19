class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page])
    @notifications.where(checked: false).each do |notification|
        notification.update(checked: true)
    end
      # 未確認の通知レコードだけ取り出し、「未確認→確認済」になるように更新。
      respond_to do |format|
        format.turbo_stream do
            render turbo_stream: [
                turbo_stream.append('notifications', partial: 'notifications/notification', collection: @notifications, as: :notification ),
                turbo_stream.replace('notifications', partial: 'notifications/notification', locals: { notifications: @notifications })
            ]
        end
        format.html
      end
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path, status: :see_other
  end
end
