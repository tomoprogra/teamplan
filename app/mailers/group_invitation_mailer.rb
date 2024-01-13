class GroupInvitationMailer < ApplicationMailer
  default from: 'from@example.com'

  def invite_email(user, group, invitation)
    @user = user
    @group = group
    @invitation = invitation
    @url = join_group_url(token: invitation.token)
    mail(to: @user.email, subject: 'グループへの招待')
  end
end

