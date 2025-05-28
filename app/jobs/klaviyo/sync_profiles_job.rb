class Klaviyo::SyncProfilesJob < ApplicationJob
  queue_as :default

  def perform
    Klaviyo::SyncProfiles.call
  end
end
