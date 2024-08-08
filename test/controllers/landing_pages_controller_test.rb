require "test_helper"

class LandingPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get landing_pages_index_url
    assert_response :success
  end
end
