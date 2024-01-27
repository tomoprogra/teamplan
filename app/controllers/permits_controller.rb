class PermitsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    permit = current_user.permits.new(group_id: params[:group_id])
    permit.save
    @group.create_notification_permit!(current_user)
    redirect_to request.referer, notice: "グループへ参加申請をしました"
  end

  def destroy
    permit = current_user.permits.find_by(group_id: params[:group_id])
    permit.destroy if permit.present?
    redirect_to request.referer, alert: "グループへの参加申請を取消しました", status: :see_other
  end
end
