require "net/http"
require "uri"
require "json"

module Klaviyo
  class Client
    BASE_URL = "https://a.klaviyo.com/api/profiles/"

    def initialize(api_key: nil)
      @api_key = api_key || Rails.application.credentials.dig(:klaviyo, :api_key)
    end

    def fetch_profiles(limit: 100)
      uri = URI("#{BASE_URL}?page[size]=#{limit}")
      req = Net::HTTP::Get.new(uri)
      req["Authorization"] = "Klaviyo-API-Key #{@api_key}"
      req["Accept"] = "application/json"
      req["revision"] = "2023-10-15"

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

      raise "Klaviyo API error: #{res.code} #{res.body}" unless res.is_a?(Net::HTTPSuccess)

      JSON.parse(res.body)
    end
  end
end
