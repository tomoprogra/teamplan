class ChatsController < ApplicationController
  include MembershipCheck
  before_action :authenticate_user!

  def index
    @group = Group.find(params[:group_id])
    @chats = @group.chats.page(params[:page]).per(6)
  end

  def create
    @group = Group.find(params[:group_id])
    @chat = @group.chats.create!(**chat_params, user: current_user)
    if @chat.save
      @group.create_notification_chat!(current_user, @chat.id)
    end

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
