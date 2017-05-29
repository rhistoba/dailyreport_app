require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:michael)
    @user2 = users(:archer)
    @report = @user2.reports.first
    @comment = @user1.comments.create!(
        content: "initial comment", report_id: @report.id)
  end

  test 'any user can comment' do
    log_in_as(@user1, 'password')
    assert_difference 'Comment.count', 1 do
      post report_comments_path(@report), params: { comment: { content: "from user1" } }, xhr: true
    end
    log_out

    log_in_as(@user2, 'password')
    assert_difference 'Comment.count', 1 do
      post report_comments_path(@report), params: { comment: {content: "from user2" } }, xhr: true
    end
  end

  test 'only current user delete own comment' do
    log_in_as(@user2, 'password')
    assert_not_equal @comment.user, @user2
    assert_no_difference 'Comment.count' do
      delete report_comment_path(@report, @comment), xhr: true
    end
    log_out

    log_in_as(@user1, 'password')
    assert_equal @comment.user, @user1
    assert_difference 'Comment.count', -1 do
      delete report_comment_path(@report, @comment), xhr: true
    end
  end

  test 'retired user cannnot operate' do
    log_in_as(@user1, 'password')
    patch user_path(@user1), params: { user: {
        password: 'password',
        password_confirmation: 'password',
        retire: true } }
    assert @user1.reload.retire?
    assert_no_difference 'Comment.count' do
      post report_comments_path(@report),
           params: { comment: { content: "from user1" } }, xhr: true
    end
    assert_no_difference 'Comment.count' do
      delete report_comment_path(@report, @comment), xhr: true
    end
  end
end
