class CreateEngagementLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :engagement_levels do |t|
      t.string :key
      t.string :value
      t.integer :sort_order

      t.timestamps
    end
    add_index :engagement_levels, :key, unique: true
  end
end
