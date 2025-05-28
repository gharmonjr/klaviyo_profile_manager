require "test_helper"

class KlaviyoProfileTest < ActiveSupport::TestCase
  test "valid with email" do
    profile = KlaviyoProfile.new(email: "test@example.com")
    assert profile.valid?
  end

  test "invalid without email" do
    profile = KlaviyoProfile.new
    assert_not profile.valid?
  end
end
