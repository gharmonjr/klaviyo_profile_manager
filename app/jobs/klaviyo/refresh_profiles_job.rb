class Klaviyo::RefreshProfilesJob < ApplicationJob
  queue_as :default

  def perform
    Klaviyo::SyncProfiles.call

    Turbo::StreamsChannel.broadcast_update_to(
      "profiles_page",
      target: "flash",
      partial: "shared/flash",
      locals: {notice: "Profiles refreshed."}
    )
  end
end
