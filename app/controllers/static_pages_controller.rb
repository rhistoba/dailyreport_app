class StaticPagesController < ApplicationController
  before_action :confirm_login

  def home
    @reports = Report.paginate(page: params[:page])
  end
end
