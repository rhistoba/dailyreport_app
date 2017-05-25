class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :set_report, only: %i(create destroy)

  def create
    # @comment = current_user.comments.build(comment_params)
    # @comment.report_id = @report.id
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = "コメントしました"
      redirect_to report_url(@comment.report)
    else
      flash[:danger] = "コメントできませんでした"
      redirect_to root_url
    end
  end

  def destroy
    report = @comment.report
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_to report_url(report)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  # beforeアクション
  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end

  def set_report
    @report = Report.find(params[:report_id])
  end
end
