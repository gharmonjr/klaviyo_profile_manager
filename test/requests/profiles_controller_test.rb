# test/requests/profiles_controller_test.rb
require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "GET /profiles returns success" do
    get profiles_path
    assert_response :success
    assert_select "h2", "Klaviyo Profiles"
  end

  test "GET /profiles?q=filter returns filtered results" do
    profile = KlaviyoProfile.create!(email: "matchme@example.com")
    get profiles_path(q: "matchme")
    assert_response :success
    assert_includes @response.body, profile.email
  end

  test "PATCH /profiles/update_engagement enqueues jobs" do
    profile1 = KlaviyoProfile.create!(email: "a@example.com")
    profile2 = KlaviyoProfile.create!(email: "b@example.com")

    assert_enqueued_jobs 2 do
      patch update_engagement_profiles_path, params: {
        profile_ids: [profile1.id, profile2.id],
        engagement_level: "medium"
      }
    end
  end

  test "POST /profiles/refresh enqueues Klaviyo::SyncProfilesJob" do
    assert_enqueued_with(job: Klaviyo::RefreshProfilesJob) do
      post refresh_profiles_path, headers: {"Accept" => "text/vnd.turbo-stream.html"}
    end

    assert_response :success
    assert_match "Refreshing Klaviyo Profiles...", @response.body
  end
end
