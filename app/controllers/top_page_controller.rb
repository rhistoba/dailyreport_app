class TopPageController < ApplicationController

  def home
    @users = User.working
    user_ids = User.working.select(:id)
    @reports  = Report.where(user_id: user_ids).order(date: :desc).paginate(page: params[:page])
  end
end
