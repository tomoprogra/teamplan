class ApplicationController < ActionController::Base
  before_action :set_groups

  private

  def set_groups
    @groups = Group.all
  end
end
