require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user_commented = users(:michael)
    @user_be_commented = users(:archer)
    @report = @user_be_commented.reports.first
    @comment = @user_commented.comments.build(
        content: "Test Comment", report_id: @report.id)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "report id should be present" do
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

  test "comment must be deleted if associated user destroyed" do
    @comment.save
    assert @comment.valid?
    assert_difference 'Comment.count', -1 do
      @user_commented.destroy
    end
  end

  test "comment must be deleted if associated report destroyed" do
    @comment.save
    assert @comment.valid?
    assert_difference 'Comment.count', -1 do
      @report.destroy
    end
  end
end
