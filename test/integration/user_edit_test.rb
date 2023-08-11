require "test_helper"

class UserEdit < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
  end
end

class UserEditTest < UserEdit
  #update 正常
  test "user#update valid" do
    log_in_as(@user)
    patch user_path(@user), params: { user: { name: "Caether",
                                                   email: "Caether@example.com"}}
    assert_redirected_to root_path
    @user.reload
    assert @user.name == "Caether"
    assert @user.email == "Caether@example.com".downcase
  end

  #update 異常
  test "user#update invalid not logged in" do
    patch user_path(@other), params: { user: { name: "Caether",
                                                    email: "Caether@example.com"}}
    assert_redirected_to new_session_path
  end

  #edit 異常
  test "user#edit invalid not logged in" do
    get edit_user_path(@user)
    assert_redirected_to new_session_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
  end

  #update 異常
  test "user#update invalid not correct_user" do
    log_in_as(@user)
    patch user_path(@other), params: { user: { name: "Caether",
                                                    email: "Caether@example.com"}}
    assert_redirected_to root_path
    assert_not flash.empty?
  end

  #update 異常 admin変更できない
  test "user#update invalid admin" do
    log_in_as(@other)
    patch user_path(@other), params: { user: { name: "Caether",
                                              email: "Caether@example.com",
                                              admin: true}}
    assert_not @other.admin?
  end

end
