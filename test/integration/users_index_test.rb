require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end
  #index 正常
  test "/index valid" do
    log_in_as(@user)
    get users_path
    users = User.page(1)
    users.each do |user|
      assert_select "a[href=?]", user_path(user)
      if user!=current_user 
        assert_select "a[href=?]", user_path(user), method: :delete
      end
    end
  end

  #index 異常
  test "/index invalid" do
    get users_path
    assert_redirected_to new_session_path
  end
end
