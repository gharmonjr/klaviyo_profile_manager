# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
EngagementLevel.upsert_all([
  {key: "very high", value: "Very High", sort_order: 1},
  {key: "high", value: "High", sort_order: 2},
  {key: "medium", value: "Medium", sort_order: 3},
  {key: "low", value: "Low", sort_order: 4},
  {key: "very low", value: "Very Low", sort_order: 5}
], unique_by: :key)
