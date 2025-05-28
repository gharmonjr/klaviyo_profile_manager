module Klaviyo
  class SyncProfiles
    def self.call
      client = Klaviyo::Client.new
      response = client.fetch_profiles

      response["data"].each do |profile_data|
        id = profile_data["id"]
        attrs = profile_data["attributes"]

        KlaviyoProfile.upsert(
          {
            klaviyo_id: id,
            email: attrs["email"],
            engagement_level: attrs["properties"]["engagement"],
            raw_data: attrs,
            synced_at: Time.current
          },
          unique_by: :klaviyo_id
        )
      end
    end
  end
end
