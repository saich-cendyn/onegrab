require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "GET /up returns plain text 'OK' with status 200" do
    get "/up"
    assert_response :success
    assert_equal "OK", @response.body
    assert_equal "text/plain", @response.media_type
  end

  test "GET /up.json returns JSON with status ok and timestamp" do
    get "/up.json"
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal "ok", json["status"]
    assert json["time"].present?
    assert_equal "application/json", @response.media_type
  end
end
