require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user_not_posted = @user_other = users(:michael)
    @user_posted = @user_curr = users(:archer)
    @report = { date: Time.now, title: "Test", content: "Test" }
  end

  test 'should show report page' do
    log_in_as(@user_posted, 'password')
    get report_path(@user_posted.reports.first)
    assert_template 'reports/show'
    log_out

    log_in_as(@user_not_posted, 'password')
    get report_path(@user_posted.reports.first)
    assert_template 'reports/show'
  end

  test 'created report should have current user id' do
    log_in_as(@user_not_posted, 'password')
    assert_difference 'Report.count', 1 do
      post reports_path params: { report: @report }
    end
    report_created = Report.order(date: :desc).first.reload
    assert_equal @user_not_posted.id, report_created.user_id
  end

  test 'only current user can edit report' do
    report = @user_curr.reports.first
    log_in_as(@user_other, 'password')
    patch report_path(report), params: { report: @report }
    assert_redirected_to root_path
    report = report.reload
    assert_not_equal report.title, @report[:title]
    assert_not_equal report.content, @report[:content]
    log_out

    log_in_as(@user_curr, 'password')
    patch report_path(report), params: { report: @report }
    assert_redirected_to report_path(report)
    report = report.reload
    assert_equal report.title, @report[:title]
    assert_equal report.content, @report[:content]
  end

  test 'only current user can delete report' do
    report = @user_curr.reports.first

    log_in_as(@user_other, 'password')
    assert_no_difference 'Report.count' do
      delete report_path(report)
    end
    log_out

    log_in_as(@user_curr, 'password')
    assert_difference 'Report.count', -1 do
      delete report_path(report)
    end
  end
end
