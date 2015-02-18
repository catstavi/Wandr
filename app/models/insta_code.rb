class InstaCode < ActiveRecord::Base
  belongs_to :location

  validates :code, presence: true
end
