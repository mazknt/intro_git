require "test_helper"

class UserSignUpTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end


  #users#create正常
  test "success users#create" do
    assert_difference "User.count", 1 do
      post users_path, params: { user: {name: "Michael",
                                        email: "Michael@example.com",
                                        password: "Michael",
                                        password_confirmation: "Michael"}}
    end
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
