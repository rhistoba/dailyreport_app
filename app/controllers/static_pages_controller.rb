class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def home
    @reports = Report.paginate(page: params[:page])
  end
end
