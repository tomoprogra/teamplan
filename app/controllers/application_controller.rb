class ApplicationController < ActionController::Base

  before_action :set_user_groups
  add_flash_types :success, :danger

  private

  # ユーザーが所属するグループの一覧
  def set_user_groups
    @user_groups = current_user.belonging_groups if current_user
  end
end
