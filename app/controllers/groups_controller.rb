class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy!
    redirect_to events_path, notice:"削除しました", status: :see_other
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to events_path, notice: "編集しました"
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

  def group_params
    params.require(:group).permit(:title)
  end
end
