class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def home
    @user = current_user
    @feed_items= current_user.feed.paginate(page: params[:page])
  end
end
