class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def confirm_login
    unless logged_in?
      redirect_to login_path
    end
  end

  # ユーザーが退職者かどうか確認する
  def confirm_retire
    redirect_to login_path if current_user.retire?
  end
end
