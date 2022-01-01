class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { in: 6..64 }
  validates :location, presence: true, length: { in: 6..64 }
  validates :event_date, presence: true

  has_many :users_events, dependent: :destroy
  has_many :attendees, through: :users_events, source: :user, dependent: :destroy
end
