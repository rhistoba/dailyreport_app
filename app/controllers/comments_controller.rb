class CommentsController < ApplicationController
  before_action :confirm_login, only: [:create, :destroy]
  before_action :confirm_editable_user, only: :destroy
  before_action :set_report, only: [:create, :destroy]

  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      @comments = @report.comments
    else
      flash[:danger] = t('flash.comment.create.danger')
      redirect_to root_path
    end
  end

  def destroy
    @comment.destroy
    @comments = @report.comments
    render :create
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  # beforeアクション
  def confirm_editable_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_path if @comment.nil?
  end

  def set_report
    @report = Report.find(params[:report_id])
  end
end
