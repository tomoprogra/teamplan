class ChatsController < ApplicationController
  include MembershipCheck
  before_action :authenticate_user!
  before_action :set_group, only: %i[index create]
  before_action :set_chats, only: %i[index create]

  def index
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chats = Chat.includes(:user).where(group_id: params[:group_id])
      respond_to do |format|
        if @chat.save
          ChatsChannel.broadcast_to(@group, render_to_string(partial: 'chats/chat', locals: { chat: @chat }))
          @group.create_notification_chat!(current_user, @chat.id)
          @chat = Chat.new
          format.html { redirect_to group_chats_path(@group) }
          format.turbo_stream
          # @group.create_notification_chat!(current_user, @chat.id)
        else
          format.html { render :index, status: :unprocessable_entity }
        end
      end
  end

  private

  def chat_params
    params.require(:chat).permit(:body).merge(user_id: current_user.id, group_id: params[:group_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_chats
    @chats = @group.chats.includes(:user)
  end
end
