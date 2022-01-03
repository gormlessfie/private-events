require "test_helper"

class OldEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get old_events_index_url
    assert_response :success
  end
end
