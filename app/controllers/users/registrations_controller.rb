# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :ensure_normal_user, only: %i[update destroy]

  # GET /resource/sign_up
  def new
    @user=User.new
  end

  # POST /resource
  def create
    @user = User.new(user_params)
  
    if User.exists?(email: @user.email) 
      flash[:alert] = "指定のメールアドレスはすでに使用されています"
      redirect_to new_user_registration_path 
    elsif @user.save
      flash[:success] = "ユーザー登録が完了しました" 
      redirect_to user_session_path
    else
      flash[:alert] = "ユーザー登録に失敗しました"
      redirect_to new_user_registration_path 
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def update
    super do |resource|
      if resource.errors.empty?
        flash[:success] = "プロフィールを更新しました"
        redirect_to request.referer and return
      else
        flash[:alert] = resource.errors.full_messages
        redirect_to request.referer and return
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def ensure_normal_user
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  
  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :profile_image, :profile_image_cache, :introduction)
    end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :introduction, :profile_image, :profile_image_cache])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :introduction, :profile_image, :profile_image_cache])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
