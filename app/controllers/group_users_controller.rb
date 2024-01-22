class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @permit = Permit.find(params[:permit_id])
    @group_user = GroupUser.create(user_id: @permit.user_id, group_id: params[:group_id])
    @permit.destroy
    redirect_to group_permits_path(@group), notice: "グループに参加しました！"
  end

  def destroy
    @group = Group.find(params[:group_id])
    @permit = Permit.find(params[:permit_id])
    @permit.destroy
    flash[:notice] = "加入を拒否しました。"
    redirect_to group_permits_path(@group), status: :see_other
  end
end
