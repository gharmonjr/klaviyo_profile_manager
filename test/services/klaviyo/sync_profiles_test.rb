class Klaviyo::SyncProfilesTest < ActiveSupport::TestCase
  test "upserts Klaviyo profiles" do
    Klaviyo::Client.any_instance.stubs(:fetch_profiles).returns({
      "data" => [
        {
          "id" => "abc123",
          "attributes" => {
            "email" => "test@example.com",
            "properties" => {"engagement" => "medium"}
          }
        }
      ]
    })

    assert_difference -> { KlaviyoProfile.count }, +1 do
      Klaviyo::SyncProfiles.call
    end

    profile = KlaviyoProfile.last
    assert_equal "test@example.com", profile.email
    assert_equal "medium", profile.engagement_level
  end
end
