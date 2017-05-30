class TopPageController < ApplicationController
  before_action :confirm_login
  before_action :confirm_retire

  def home
    @users = User.working
    user_ids = User.working.select(:id)
    @reports  = Report.where(user_id: user_ids).order(date: :desc).paginate(page: params[:page])
  end
end
