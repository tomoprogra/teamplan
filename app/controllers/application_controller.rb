class ApplicationController < ActionController::Base
  before_action :set_groups
  before_action :set_user_groups

  private

  def set_groups
    @groups = Group.all
  end

  # ユーザーが所属するグループの一覧
  def set_user_groups
    @user_groups = current_user.belonging_groups if current_user
  end
end
