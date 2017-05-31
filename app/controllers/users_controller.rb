class UsersController < ApplicationController
  before_action :confirm_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :confirm_updatable, only: :update
  before_action :confirm_deletable, only: :destroy

  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    else
      @users = User.working.paginate(page: params[:page])
    end
  end

  def show
    confirm_admin if @user.retire?
    @reports = @user.reports.order(date: :desc).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = t('flash.user.create.info')
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t('flash.user.update.success')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t('flash.user.destroy.success')
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(
        :name, :email, :password, :password_confirmation,
        :department, :admin, :retire)
  end

  # beforeアクション

  def confirm_admin
    redirect_to(root_path) unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def confirm_updatable
    if admin_working_to_retire_or_not_admin? && @user.less_working_admin?
      flash[:danger] = t('flash.user.update.less_working_admin')
      render 'edit'
    end
  end

  def confirm_deletable
    if @user.less_working_admin?
      flash[:danger] = t('flash.user.destroy.less_working_admin')
      redirect_to users_path
    end
  end

  def admin_working_to_retire_or_not_admin?
    @user.admin? && !@user.retire? &&
        (user_params[:retire]=='true' || user_params[:admin]=='false')
  end
end
