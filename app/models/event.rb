class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { in: 3..64 }
  validates :location, presence: true, length: { in: 3..64 }
  validates_datetime :event_date, on_or_after: :now,
                                  on_or_after_message: 'must be in the future.'
  validates :status, presence: true, inclusion: { in: %w(public private) }

  has_many :users_events, dependent: :destroy
  has_many :attendees, through: :users_events, source: :user, dependent: :destroy
end
