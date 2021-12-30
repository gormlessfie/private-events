class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { in: 6..64 }
  validates :event_date, presence: true
end
