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
      post comments_path params: { comment: { content: "from user1", report_id: @report.id } }
    end
    assert_redirected_to report_url(@report)
    log_out

    log_in_as(@user2, 'password')
    assert_difference 'Comment.count', 1 do
      post comments_path params: { comment: {content: "from user2", report_id: @report.id } }
    end
    assert_redirected_to report_url(@report)
  end

  test 'only current user delete own comment' do
    log_in_as(@user2, 'password')
    assert_not_equal @comment.user, @user2
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to root_url
    log_out

    log_in_as(@user1, 'password')
    assert_equal @comment.user, @user1
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment)
    end
    assert_redirected_to report_url(@report)
  end
end
