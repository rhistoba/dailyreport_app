class ReportsController < ApplicationController
  before_action :confirm_login
  before_action :confirm_editable_user, only: [:edit, :update, :destroy]
  before_action :set_report, only: [:show, :edit, :update]

  def show
    @comment = current_user.comments.build
    @comments = @report.comments
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
  end

  def update
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
  def confirm_editable_user
    @report = Report.find(params[:id])
    redirect_to(root_url) unless @report.user == current_user
  end

  def set_report
    @report = Report.find(params[:id])
  end

end
