class ChatsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    #@group = Group.find(params[:group_id])
    stream_for Group.find(params[:group_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def get_user_data
    data = {
      id: current_user.id,
      email: current_user.email,
      username: current_user.email.split('@')[0],
    }

    ActionCable.server.broadcast 'chats_channel', { user: data }
  end
end