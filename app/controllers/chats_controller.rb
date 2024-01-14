class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @group = Group.find(params[:group_id])
    @chats = @group.chats
  end

  def create
    group = Group.find(params[:group_id])
    group.chats.create!(**chat_params, user: current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chats }
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:body)
  end
end
