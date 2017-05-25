class CommentsController < ApplicationController
  before_action :confirm_login, only: [:create, :destroy]
  before_action :confirm_editable_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "コメントしました"
      redirect_to @comment.report
    else
      flash[:danger] = "コメントできませんでした"
      redirect_to root_path
    end
  end

  def destroy
    @report = @comment.report
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_to @report
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :report_id)
  end

  # beforeアクション
  def confirm_editable_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_path if @comment.nil?
  end
end
