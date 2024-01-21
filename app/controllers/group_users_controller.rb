class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @permit = Permit.find(params[:permit_id])
    @group_user = GroupUser.create(user_id: @permit.user_id, group_id: params[:group_id])
    @permit.destroy #参加希望者リストから削除する
    redirect_to group_permits_path(@group), notice: "グループに参加しました！"
  end
end
