class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
    @user_groups = @user.groups
  end

  def events_for_date
    @user = current_user
    @user_groups = @user.groups
    @selected_date = params[:date]&.to_date || Date.current
    @events_for_selected_date = @user.events_for_calendar_by_date(@selected_date)
  end
end
