require "test_helper"

class UserLogIn < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  include SessionsHelper

  def setup
    @user = users(:michael)
  end
end

class UserLogInTest < UserLogIn 
  #ログイン異常 原因不明のエラー　BCrypt::Errors::InvalidHash: invalid hash
  test "invalid login" do
    post session_url, params: { session: {email: @user.email, 
                                          password: "invalid_password",
                                          remember_me: "0"}}
    assert_template "sessions/new"
    assert_not flash.empty?
    assert_select "a[href=?]", new_session_path
  end

  #ログイン正常
  test "valid login" do
    log_in_as(@user)
    get user_path(@user)
    assert_select "a[href=?]", session_path, method: :delete
    assert_select "a[href=?]", user_path(@user)
  end
end

class UserLogOut < UserLogIn
  def setup
    super
    log_in_as(@user)
  end
end

class UserLogOutTest < UserLogIn
  #ログアウト
  test "valid logout" do
    post session_path, params: { session: { email:    @user.email,
                                            password: 'password' } }
    
    assert is_logged_in?
    delete session_path
    assert_redirected_to root_url
    assert_response :see_other
    assert_not is_logged_in?
    #2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete session_path
    follow_redirect!
    assert_select "a[href=?]", new_session_path
    assert_select "a[href=?]", session_path, method: :delete, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

