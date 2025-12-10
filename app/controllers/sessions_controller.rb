class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :validate_login_params, only: [:create]

  def new; end

  def create
    user = User.authenticate_by_email_case_insensitive(
      email: params[:email],
      password: params[:password]
    )

    unless user
      flash.now[:alert] = "メールアドレスとパスワードが一致するユーザーが存在しません"
      render :new, status: :unprocessable_entity
      return
    end

    session[:user_id] = user.id
    redirect_to photos_path, notice: "ログインしました"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "ログアウトしました"
  end

  private

  def validate_login_params
    errors = []
    errors << "メールアドレスが未入力です" if params[:email].blank?
    errors << "パスワードが未入力です" if params[:password].blank?

    return if errors.empty?

    flash.now[:alerts] = errors
    render :new, status: :unprocessable_entity
  end
end

