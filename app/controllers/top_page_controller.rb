class TopPageController < ApplicationController
  before_action :confirm_login
  before_action :confirm_retire

  def home
    user_ids = User.working.select(:id)
    @reports_user = Report.where(user: current_user)
    @reports_all  = Report.where(user_id: user_ids).order(date: :desc).paginate(page: params[:page])
  end
end
