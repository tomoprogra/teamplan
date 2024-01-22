class GroupUsersController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_correct_user, only: [:create,:destroy]

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

  private

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      flash[:alert] = "グループオーナーのみ編集が可能です"
      redirect_to group_path(@group)
    end
  end
end
