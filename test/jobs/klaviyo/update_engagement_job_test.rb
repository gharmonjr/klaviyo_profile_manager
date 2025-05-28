require "test_helper"

class Klaviyo::UpdateEngagementJobTest < ActiveJob::TestCase
  test "updates engagement level and triggers broadcast" do
    stub_request(:patch, %r{https://a\.klaviyo\.com/api/profiles/}).to_return(status: 200, body: "", headers: {})


    profile = KlaviyoProfile.create!(email: "foo@example.com")
    valid_level = engagement_levels(:high).key
    Klaviyo::UpdateEngagementJob.perform_now(profile.id, valid_level)

    assert_broadcasts("profiles_page", 1)
  end
end
