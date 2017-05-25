require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:michael)
    @user2 = users(:archer)
    @user1.reports.create!(
        date: Time.local(2017, 5, 23), title: "Test title", content: "Test content")
    @reports = Report.all
  end

  test 'correct links' do
    log_in_as(@user1, 'password')
    get root_path
    @reports.each do |report|
      assert_select 'a', href: report
      assert_select 'a', href: report.user
    end
  end

end
