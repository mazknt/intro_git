ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  #Application helper 
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  def log_in_as(user)
    session[:user_id] = user.id
  end

  def is_logged_in?
    !current_user.nil?
  end
end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post session_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end