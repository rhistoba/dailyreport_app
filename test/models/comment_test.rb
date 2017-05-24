require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user_not_posted = users(:michael)
    @user_posted = users(:archer)
    @report = @user_posted.reports.first
    @comment = Comment.new(content: "Test Comment",
                           user_id: @user_not_posted.id,
                           report_id: @report.id)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "user id and report id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
    @comment.user_id = @user_not_posted.id
    @comment.report_id = nil
    assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.content = ''
    assert_not @comment.valid?
  end

  test "content should be maximum 400" do
    @comment.content = 'あ' * 400
    assert @comment.valid?
    @comment.content = 'あ' * 401
    assert_not @comment.valid?
  end
end
