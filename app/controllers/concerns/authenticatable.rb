module Authenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  private

  # セキュリティ上問題ないというにはHTTPSを前提とする必要があるが、開発環境なのでHTTPでも許容する
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    return if logged_in?

    redirect_to root_path, alert: "ログインが必要です"
  end
end

