ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # テストユーザーとしてログインする
  def log_in_as(user, password='')
    #session[:user_id] = user.id
    get login_path
    post login_path params: {
        session: { email: user.email, password: password } }
  end

  # ログアウトする
  def log_out
    delete logout_path
  end


end
