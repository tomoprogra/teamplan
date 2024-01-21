module MembershipCheck
  extend ActiveSupport::Concern

  included do
    before_action :check_membership
  end

  private

  def check_membership
    @group = Group.find(params[:group_id])
    unless @group.members.include?(current_user)
      flash[:alert] = "グループに参加してください。"
      redirect_to root_path
    end
  end
end