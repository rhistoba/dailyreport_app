class ReportsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @report = Report.find(params[:id])
  end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      flash[:info] = "新しい日報を作成しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(report_params)
      flash[:success] = "日報を変更しました"
      redirect_to report_url(@report)
    else
      render 'edit'
    end
  end

  def destroy
    Report.find(params[:id]).destroy
    flash[:success] = "日報を削除しました"
    redirect_to root_path
  end

  private
  def report_params
    params.require(:report).permit(:date, :title, :content)
  end

  # beforeアクション
  def correct_user
    @report = Report.find(params[:id])
    redirect_to(root_url) unless @report.user == current_user
  end

end
