class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_membership, only: [:update, :destroy, :edit, :show]
  before_action :ensure_correct_user, only: [:destroy, :permits]
  before_action :ensure_normal_user, only: [:add_member, :invite, :new, :create, :destroy, :edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group.users << current_user
      @group.create_notification_join!(current_user)
      redirect_to group_events_path(@group), success: t('defaults.flash_message.created', item: Group.model_name.human)
    else
      flash[:danger] = t('defaults.flash_message.not_created', item: Group.model_name.human)
      redirect_to request.referer and return
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.owner_id == current_user.id
      @group.destroy!
      redirect_to root_path, success: t('defaults.flash_message.delete', item: Group.model_name.human), status: :see_other
    else
      flash[:alert] = "グループオーナーのみ削除が可能です"
      redirect_to group_path(@group)
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_events_path(@group), success: t('defaults.flash_message.updated', item: Group.model_name.human)
    else
      flash[:alert] = @group.errors.full_messages
      redirect_to request.referer and return
    end
  end

  def show
    @group = Group.find(params[:id])
    @events = @group.events
    @users = @group.users
  end

  def add_member
    invitation = Invitation.find_by(token: params[:token])
    if invitation && !invitation.group.users.include?(invitation.user)
      invitation.group.users << invitation.user
      # 成功のメッセージ
      redirect_to group_path(invitation.group), notice: "グループに参加しました！"
    else
      # エラーメッセージ
      redirect_to root_path, alert: "無効な招待です。"
    end
  end

  def invite
    group = Group.find(params[:id])
    email = params[:email].downcase
    user = User.find_by(email: email)

    if user
      invitation = Invitation.create(user: user, group: group)
      GroupInvitationMailer.invite_email(user, group, invitation).deliver_now
      flash[:notice] = "#{email} に招待メールを送信しました。"
    else
      flash[:alert] = "#{email} は登録されているメールアドレスではありません。"
    end
    redirect_to group_path(group)
  end

  def leave
    group = Group.find(params[:id])

    if group.owner_id == current_user.id && params[:user_id].to_i == current_user.id
      flash[:alert] = "グループホストはグループから脱退できません。"
      redirect_to group_path(group)
      return
    end

    user_id = params[:user_id].to_i
    user_group = group.group_users.find_by(user_id: user_id)
    user_group.destroy
    
    if group.owner_id == current_user.id
      flash[:notice] = "グループから脱退させました。"
      redirect_to group_path(group)
    else
      flash[:notice] = "グループから脱退しました。"
      redirect_to root_path
    end
  end
  
  def permits
    @group = Group.find(params[:id])
    @permits = @group.permits.page(params[:page])
  end

  def new_permit
    @group = Group.find(params[:id])
    @permit = Permit.new
    if @group.members.include?(current_user)
      flash[:alert] = 'すでにグループに所属しています。'
      redirect_to root_path
    end
  end
  private

  def check_membership
    @group = Group.find(params[:id])
    unless @group.members.include?(current_user)
      flash[:alert] = "グループに参加してください"
      redirect_to root_path
    end
  end

  def group_params
    params.require(:group).permit(:title)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group), alert: "グループオーナーのみ編集が可能です"
    end
  end

  def ensure_normal_user
    if current_user.email == 'guest@example.com'
      redirect_to root_path, notice: "ゲストユーザーではできない動作です。"
    end
  end
end

