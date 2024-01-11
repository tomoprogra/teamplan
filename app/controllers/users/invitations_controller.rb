class Users::InvitationsController < Devise::InvitationsController
  protect_from_forgery except: :accept_invitation
  # before_action :direct_to_sign_in, only: [:update]

  def new
    @group = Group.find_by(id: params[:group_id])
    @user = User.new
  end

  # def edit
  #   @user = User.find_by_invitation_token(params[:invitation_token], false)
  #   redirect_to new_user_registration_path unless @user
  # end

  def destroy
    super
  end

  def create
    @user = User.new
    user_email = params[:user][:email]
    group_id = params[:user][:group_id]
    if User.find_by(email: user_email.downcase).present? #　既存ユーザーの処理
      user_id = User.where(email: user_email.downcase).pluck(:id)
      user = User.find(user_id[0])
      user.invite!(current_user)
      user.invited_by_group_id = group_id
      user.save
      redirect_to groups_path(current_user), notice: "招待メールが#{user_email}に送信されました。"
    elsif User.invite!(email: user_email, invited_by_group_id: group_id).valid?  # 新規ユーザーの処理
      redirect_to groups_path(current_user), notice: "招待メールが#{user_email}に送信されました。"
    else
      flash[:notice] = 'メールアドレスを正しく入力してください。'
      render 'new', locals: { group: group_id }
    end
  end

  # def update
  #   user = User.find_by_email(resource_params[:email])
  
  #   if user && user.valid_password?(resource_params[:password])
  #     # 既存のユーザーの場合、そのユーザーをサインインさせてからグループに追加します。
  #     sign_in(user)
  #     group = Group.find_by(invitation_token: params[:user][:invitation_token])
  #     if group
  #       group.users << user unless group.users.include?(user) # ユーザーがまだグループに含まれていない場合にのみ追加
  #     end
  #     redirect_to(root_path) 
  #     return # メソッドから抜け出します
  #   else
  #     # 新規ユーザーの場合、Deviseのデフォルトの動作を実行します（新規登録画面へリダイレクト）。
  #     super do |resource|
  #       if resource.errors.empty?
  #         group = Group.find_by(invitation_token: params[:user][:invitation_token])
  #         if group
  #           group.users << resource
  #         end
  #       end
  #     end
  #   end
  # end
  
  def accept_invitation
    @user = User.find_by_invitation_token(params[:invitation_token], true)
    
    if @user
      @group = Group.find(params[:group_id]) 
      @group.users << @user
      redirect_to @group, notice: 'You have successfully joined the group.'
    else
      redirect_to root_path, alert: 'Invalid invitation token.'
    end
  end
end

