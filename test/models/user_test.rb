require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
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
end
