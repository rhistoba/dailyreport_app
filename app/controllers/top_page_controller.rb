class TopPageController < ApplicationController
  before_action :confirm_login

  def home
    user_ids = User.where(retire: false).select(:id)
    @reports = Report.where(user_id: user_ids).order(date: :desc).paginate(page: params[:page])
  end
end
