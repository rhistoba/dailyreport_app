require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @user_retired = users(:retire)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'}}
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", logout_path, count: 1
  end

  test "should not show home page without login" do
    get root_path
    assert_redirected_to login_path
  end

  test 'retired user cannot login' do
    assert @user_retired.retire?
    post login_path, params: { session: { email: @user_retired.email, password: 'password' } }
    assert_template 'sessions/new'
    assert_match 'そのユーザーは退職済みのためログインできません', response.body
  end

end
