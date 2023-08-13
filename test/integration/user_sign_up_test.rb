require "test_helper"

class UserSignUp < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end
end
class UserSignUpTest < UserSignUp
  #users#create正常
  test "success users#create" do
    assert_difference "User.count", 1 do
      post users_path, params: { user: {name: "Michael",
                                        email: "Michael@example.com",
                                        password: "Michael",
                                        password_confirmation: "Michael"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
  end

  #users#create異常
  test "not success users#create" do
    assert_no_difference "User.count" do
      post users_path, params: { user: {name: " ",
                                        email: "Michael@example.com",
                                        password: "Michael",
                                        password_confirmation: "Michael"}}
    end
    assert flash.empty?
    assert_template "users/new", status: :unprocessable_entity
  end
end

class AccountActivation < UserSignUp
  def setup
    super
    post users_path, params: { user: { name:  "Example User",
      email: "user@example.com",
      password:              "password",
      password_confirmation: "password" } }
    @user = assigns(:user)
  end
end

class AccountActivationTest < AccountActivation
  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_activate_account_url("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_activate_account_url(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_activate_account_url(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
