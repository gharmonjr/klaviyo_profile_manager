require "test_helper"
class Klaviyo::SyncProfilesJobTest < ActiveJob::TestCase
  test "calls the sync service" do
    Klaviyo::SyncProfiles.expects(:call)
    Klaviyo::SyncProfilesJob.perform_now
  end
end
