require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  #リンクのテスト
  test "static_pages#home" do
    get root_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", root_path, conut: 2
  end
end
