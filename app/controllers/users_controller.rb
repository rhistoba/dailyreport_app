class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :confirm_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_user, only: %i(show edit update)

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @reports = @user.reports.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "新しいユーザー" + @user.name + "を作成しました"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(
        :name, :email, :password, :password_confirmation, :department)
  end

  # beforeアクション

  # 管理者かどうか確認
  def confirm_admin
    redirect_to(root_path) unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end
