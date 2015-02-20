class Photo < ActiveRecord::Base
  belongs_to :location

  scope :not_flagged, -> { where(flags: 0) }
end
