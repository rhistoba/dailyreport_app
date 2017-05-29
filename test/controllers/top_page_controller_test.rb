require 'test_helper'

class TopPageControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:michael)
  end

  test 'retired user cannnot operate' do
    log_in_as(@admin_user, 'password')
    patch user_path(@admin_user), params: { user: {
        password: 'password',
        password_confirmation: 'password',
        retire: true } }
    assert @admin_user.reload.retire?
    get root_path
    assert_redirected_to login_path
  end
end
