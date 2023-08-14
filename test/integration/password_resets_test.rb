require "test_helper"

class PasswordResets < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class ForgotPasswordFormTest < PasswordResets

  test "password reset path" do
    get new_reset_password_path
    assert_template 'reset_passwords/new'
    assert_select 'input[name=?]', 'reset_password[email]'
  end

  test "reset path with invalid email" do
    post reset_passwords_path, params: { reset_password: { email: "" } }
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template 'reset_passwords/new'
  end
end

class PasswordResetForm < PasswordResets

  def setup
    super
    @user = users(:michael)
    post reset_passwords_url,
         params: { reset_password: { email: @user.email } }
    @reset_user = assigns(:user)
  end
end

class PasswordFormTest < PasswordResetForm

  test "reset with valid email" do
    assert_not_equal @user.reset_digest, @reset_user.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "reset with wrong email" do
    get edit_reset_password_path(@reset_user.reset_token, email: "")
    assert_redirected_to root_url
  end

  test "reset with inactive user" do
    @reset_user.toggle!(:activated)
    get edit_reset_password_path(@reset_user.reset_token,
                                 email: @reset_user.email)
    #assert_redirected_to root_url
  end

  test "reset with right email but wrong token" do
    get edit_reset_password_path('wrong token', email: @reset_user.email)
    assert_redirected_to root_url
  end

  test "reset with right email and right token" do
    get edit_reset_password_path(@reset_user.reset_token,
                                 email: @reset_user.email)
    assert_template 'reset_passwords/edit'
    assert_select "input[name=email][type=hidden][value=?]", @reset_user.email
  end
end

class PasswordUpdateTest < PasswordResetForm

  test "update with invalid password and confirmation" do
    patch reset_password_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
  end

  test "update with empty password" do
    patch reset_password_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
  end
  test "update with valid password and confirmation" do
    patch reset_password_path(@reset_user.reset_token),
          params: { email: @reset_user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @reset_user
  end
end
