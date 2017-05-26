class TopPageController < ApplicationController
  before_action :confirm_login

  def home
    @reports = Report.order(date: :desc).paginate(page: params[:page])
  end
end
