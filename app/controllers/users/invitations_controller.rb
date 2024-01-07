class Users::InvitationsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    create_invitation unless Invitation.any?
    set_invitation_token_url
  end

  def create
    create_invitation
    set_invitation_token_url
    flash[:success] = "招待URLを再発行しました。"
    redirect_to users_invitations_path
  end
  
  private
  
  def create_invitation
    Invitation.create!(token: SecureRandom.uuid.gsub!(/-/,''))
  end
  
  def set_invitation_token_url
    @invitation_token_url = invitation_url(Invitation.last.token)
  end
  
  def invitation_url(token)
    url_for(controller: 'users/registrations', action: 'new', tk: token, host: request.host_with_port)
  end
end

