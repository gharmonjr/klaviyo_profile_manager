class CreateKlaviyoProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :klaviyo_profiles do |t|
      t.string :klaviyo_id
      t.string :email
      t.string :engagement_level
      t.jsonb :raw_data
      t.datetime :synced_at

      t.timestamps
    end
    add_index :klaviyo_profiles, :klaviyo_id, unique: true
  end
end
