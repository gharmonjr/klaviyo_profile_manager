class Klaviyo::ClientTest < ActiveSupport::TestCase
  test "fetches profiles from Klaviyo" do
    stub_request(:get, "https://a.klaviyo.com/api/profiles/?page[size]=100")
      .with(
        headers: {
          "Authorization" => "Klaviyo-API-Key #{Rails.application.credentials.dig(:klaviyo, :api_key)}",
          "Accept" => "application/json",
          "Revision" => "2023-10-15"
        }
      )
      .to_return(
        body: {
          data: [
            {
              id: "123",
              attributes: {
                email: "user@example.com",
                properties: {"engagement" => "high"}
              }
            }
          ]
        }.to_json,
        headers: {"Content-Type" => "application/json"}
      )

    client = Klaviyo::Client.new
    result = client.fetch_profiles

    assert_equal "user@example.com", result["data"].first["attributes"]["email"]
  end
end
