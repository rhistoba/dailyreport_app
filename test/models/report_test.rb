require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @report = @user.reports.build(date: Time.local(2017,5,1),
                                  title: "Example",
                                  content: "Content Example",
                                  user_id: @user.id)
  end

  test "should be valid" do
    assert @report.valid?
  end

  test "user id should be present" do
    @report.user_id = nil
    assert_not @report.valid?
  end

  test "title length must be muximum 100" do
    @report.title = "あ" * 100
    assert @report.valid?
    @report.title = "あ" * 101
    assert_not @report.valid?
  end

  test "content length must be muximum 1000" do
    @report.content = "あ" * 1000
    assert @report.valid?
    @report.content = "あ" * 1001
    assert_not @report.valid?
  end

  test "a user can create only 1 report per 1 day" do
    time_now = Time.now
    report_today = @user.reports.create!(date:time_now, title:"1",
                                  content:"1", user_id:@user.id)
    report_sameday = @user.reports.build(date:time_now, title:"2",
                                  content:"2", user_id:@user.id)
    report_nextday = @user.reports.build(date:time_now.next_day, title:"3",
                                         content:"3", user_id:@user.id)
    assert_not report_sameday.valid?
    assert report_nextday.valid?
  end

end
