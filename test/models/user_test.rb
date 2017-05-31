require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar",
                     department: "Management", admin: true, retire: false)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be invalid" do
    @user.name = ""
    assert_not @user.valid?
    @user.name = "あ" * 51
    assert_not @user.valid?
  end

  test "email should be invalid" do
    invalid_emails = ["", "userexample.com",
                     "@example.com", "user@example", "user@@example.com",
                     "user@", "@.com", "user@example@example.com"]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?
    end
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "associated reports should be destroyed" do
    @user.save
    @user.reports.create!(date:Time.now, title:"1",
                          content:"1", user_id:@user.id)
    assert_difference 'Report.count', -1 do
      @user.destroy
    end
  end

  test 'department must not be nil' do
    @user.department = nil
    assert_not @user.valid?
  end

  test 'department length must be maximum 50' do
    @user.department = 'あ' * 50
    assert @user.valid?
    @user.department = 'あ' * 51
    assert_not@user.valid?
  end

  test 'working admin must be at least 1 person' do
    assert_equal User.where(admin: true, retire: false).count,1
    user = User.find_by(admin: true, retire: false)
    user.password = user.password_confirmation = 'password'
    assert user.valid?

    user.admin = false
    assert_not user.valid?
    user.admin = true
    assert user.valid?
    user.retire = true
    assert_not user.valid?

    user.retire = false
    assert user.valid?
    assert_no_difference 'User.where(admin: true, retire: false).count' do
      user.destroy
    end
  end


end
