class SessionsController < ApplicationController
  skip_before_action :confirm_login
  skip_before_action :confirm_retire

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.retire?
        flash.now[:danger] = t('flash.session.create.retire')
        render 'new'
      else
        log_in user
        redirect_to root_path
      end
    else
      flash.now[:danger] = t('flash.session.create.danger')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
