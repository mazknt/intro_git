require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal "Sample App Second", full_title("")
    assert_equal "Sample App Second || Help", full_title("Help")
  end
end
