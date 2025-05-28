class KlaviyoProfile < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :engagement_level, inclusion: {in: ->(_) { EngagementLevel.pluck(:key) }, allow_blank: true}
end
