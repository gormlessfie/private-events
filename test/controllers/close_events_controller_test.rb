require "test_helper"

class CloseEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get close_events_index_url
    assert_response :success
  end
end
