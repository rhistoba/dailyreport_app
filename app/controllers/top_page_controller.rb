class TopPageController < ApplicationController

  def home
    @users = User.working
    @calendar_user = User.find_by(name: params[:calendar_user_name]) || current_user
    user_ids = User.working.select(:id)
    @reports  = Report.where(user_id: user_ids).order(date: :desc).paginate(page: params[:page])
  end
end
