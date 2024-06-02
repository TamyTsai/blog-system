# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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

  # protected
  # 只能在類別中使用，要不要指定明確接收者都可以
  private
  # 只能在類別中使用，限定不能有明確接收者
  # 不需要被類別外面存取的方法

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :intro])
  end
  # 編輯更新個人資料
  # 自己客制化增加username與intro欄位，所以要來這裡開
  # rails permmit效果
  # 幫你把強參數（strong params）再加兩個欄位進來，讓username與intro欄位可以順利通過強參數

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  # 讓使用者可以不輸入當前密碼 就更新個人資料
  # https://github.com/heartcombo/devise/issues/4308

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
