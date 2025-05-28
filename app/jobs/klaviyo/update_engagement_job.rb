require "net/http"
require "uri"
require "json"

class Klaviyo::UpdateEngagementJob < ApplicationJob
  queue_as :default

  def perform(profile_id, engagement_level)
    profile = KlaviyoProfile.find_by(id: profile_id)
    return unless profile

    response = patch_engagement_to_klaviyo(profile.klaviyo_id, engagement_level)

    if response.is_a?(Net::HTTPSuccess)
      profile.update!(engagement_level: engagement_level)
      broadcast_reload
    else
      Rails.logger.error("Failed to update Klaviyo profile #{profile.klaviyo_id}: #{response.code} #{response.body}")
    end
  end

  private

  def patch_engagement_to_klaviyo(klaviyo_id, engagement_level)
    uri = URI("https://a.klaviyo.com/api/profiles/#{klaviyo_id}/")
    req = Net::HTTP::Patch.new(uri)
    req["Authorization"] = "Klaviyo-API-Key #{Rails.application.credentials.dig(:klaviyo, :api_key)}"
    req["Accept"] = "application/json"
    req["Content-Type"] = "application/json"
    req["revision"] = "2023-10-15"

    req.body = {
      data: {
        type: "profile",
        id: klaviyo_id,
        attributes: {
          properties: {
            engagement: engagement_level
          }
        }
      }
    }.to_json

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  end

  def broadcast_reload
    Turbo::StreamsChannel.broadcast_update_to(
      "profiles_page",
      target: "profiles_page",
      partial: "profiles/reload"
    )
  end
end
