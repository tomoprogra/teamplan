class GroupsController < ApplicationController
  before_action :check_membership, only: [:update, :destroy, :edit, :show]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.users << current_user
      redirect_to group_events_path(@group), success: t('defaults.flash_message.created', item: Group.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Group.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy!
    redirect_to root_path, success: t('defaults.flash_message.delete', item: Group.model_name.human), status: :see_other
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_events_path(@group), success: t('defaults.flash_message.updated', item: Group.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @group = Group.find(params[:id])
    @events = @group.events
    @users = @group.users
  end

  private

  def check_membership
    unless current_user.belongs_to_group?(@group)
      redirect_to root_path, flash.now[:alert] = "グループに参加してください"
    end
  end

  def group_params
    params.require(:group).permit(:title)
  end
end
