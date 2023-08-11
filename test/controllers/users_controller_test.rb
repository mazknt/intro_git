require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    log_in_as(@user)
    @other = users(:archer)
  end

  #destroy 正常
  test "#destroy valid" do
    get users_path
    User.page(1).each do |user|
      if user != @user
        assert_select "a[href=?]", user_path(user), method: :destroy
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@other)
    end
  end

  #destroy 異常
  test "#destroy invalid" do
    log_in_as(@other)
    get users_path
    User.page(1).each do |user|
      assert_select "a[href=?]", user_path(user), method: :destroy, conut: 0
    end
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to users_path
  end

end
