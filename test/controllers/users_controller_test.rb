require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:michael)
    @not_admin_user = users(:archer)
    @retired_user = users(:retire)
  end

  test "should show all users in users page" do
    log_in_as(@admin_user, 'password')
    get users_path
    assert_template 'users/index'
    users.each do |user|
      assert_select 'a[href=?]', user.name
    end
  end

  test "only admin user can create and delete user" do
    new_user = {name: "Hoge Hoge", email: "hoge@example.com",
                password: "foobar", password_confirmation: "foobar",
                department: "Department"}

    log_in_as(@not_admin_user, 'password')
    assert_no_difference 'User.count' do
      post users_path params: { user: new_user }
    end
    log_out

    log_in_as(@admin_user, 'password')
    assert_difference 'User.count', 1 do
      post users_path params: { user: new_user }
    end
    user_created = User.last.reload
    assert new_user[:name] == user_created.name
    assert new_user[:email] == user_created.email
    log_out

    log_in_as(@not_admin_user, 'password')
    assert_no_difference 'User.count' do
      delete user_path(user_created)
    end
    log_out

    log_in_as(@admin_user, 'password')
    assert_difference 'User.count', -1 do
      delete user_path(user_created)
    end
  end

  test "only admin user can edit user info" do
    edited_info ={ name: "Fuga Fuga", email: "fuga@example.com",
                   password: "foobar", password_confirmation: "foobar"}

    log_in_as(@not_admin_user, 'password')
    patch user_path(@not_admin_user), params: { user: edited_info }
    assert_redirected_to root_url
    reload_user = @not_admin_user.reload
    assert_not reload_user.name == edited_info[:name]
    assert_not reload_user.email == edited_info[:email]
    log_out

    log_in_as(@admin_user, 'password')
    patch user_path(@not_admin_user), params: { user: edited_info }
    assert_redirected_to user_path(@not_admin_user)
    reload_user = @not_admin_user.reload
    assert reload_user.name == edited_info[:name]
    assert reload_user.email == edited_info[:email]
  end

  test "create admin user" do
    new_user = {name: "Hoge Hoge", email: "hoge@example.com",
                password: "foobar", password_confirmation: "foobar",
                department: "Department", admin: true}

    log_in_as(@not_admin_user, 'password')
    assert_no_difference 'User.count' do
      post users_path params: { user: new_user }
    end
    log_out

    log_in_as(@admin_user, 'password')
    assert_difference 'User.count', 1 do
      post users_path params: { user: new_user }
    end
    user_created = User.last.reload
    assert user_created.admin?
  end

  test 'delete admin user' do
    new_user = {name: "Hoge Hoge", email: "hoge@example.com",
                password: "foobar", password_confirmation: "foobar",
                department: "Department", admin: true}

    log_in_as(@admin_user, 'password')
    post users_path params: { user: new_user }
    user_created = User.last.reload
    assert user_created.admin?

    assert_difference 'User.count', -1 do
      delete user_path(user_created)
    end

    # admin userが１人だけなら削除されないはず
    assert_no_difference 'User.count' do
      delete user_path(@admin_user)
    end
  end

  test 'set retire user' do
    post users_path params: {
        user: {name: "Hoge Hoge", email: "hoge@example.com",
               password: "foobar", password_confirmation: "foobar",
               department: "Department", admin: false, retire: false } }
    user = User.last.reload
    assert_not user.retire?

    log_in_as(@admin_user, 'password')
    patch user_path(user), params: {
        user:
            { name: "Edited", email: "hoge@example.com",
              password: "foobar", password_confirmation: "foobar",
              department: "Department", retire: true } }
    assert user.reload.retire?
  end

  test 'only admin user can access retired user page' do
    log_in_as(@not_admin_user, 'password')
    get user_path(@retired_user)
    assert_redirected_to root_path
    log_out

    log_in_as(@admin_user, 'password')
    get user_path(@retired_user)
    assert_template 'users/show'
    assert_match @retired_user.name, response.body
    assert_match @retired_user.email, response.body
    assert_match @retired_user.department, response.body
  end

  test 'retired user cannnot operate' do
    log_in_as(@admin_user, 'password')
    patch user_path(@admin_user), params: { user: {
        password: 'password',
        password_confirmation: 'password',
        retire: true } }
    assert @admin_user.reload.retire?
    get users_path
    assert_redirected_to login_path
  end
end
