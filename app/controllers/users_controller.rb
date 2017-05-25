class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :confirm_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.reports.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "新しいユーザー" + @user.name + "を作成しました"
      redirect_to users_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
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
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(
        :name, :email, :password, :password_confirmation, :department)
  end

  # beforeアクション

  # 管理者かどうか確認
  def confirm_admin
    redirect_to(root_url) unless current_user.admin?
  end

end
