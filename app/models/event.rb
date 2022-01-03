class Event < ApplicationRecord 
  EVENTS_PER_PAGE = 2

  scope :past_events, -> { where('event_date < ?', DateTime.now) }
  scope :page_limit, -> (page) { offset(page * EVENTS_PER_PAGE)
                         .limit(EVENTS_PER_PAGE) }
  scope :close_events, -> { where(event_date: DateTime.now..DateTime.now + 30.days) }
  scope :active_events, -> { where('event_date > ?', DateTime.now) }
  scope :public_events, -> { where(status: 'public') }

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { in: 3..64 }
  validates :location, presence: true, length: { in: 3..64 }
  validates_datetime :event_date, on_or_after: :now,
                                  on_or_after_message: 'must be in the future.'
  validates :status, presence: true, inclusion: { in: %w(public private) }

  has_many :users_events, dependent: :destroy
  has_many :attendees, through: :users_events, source: :user, dependent: :destroy


  # Callbacks
  after_create :add_host_to_attending

  private
  
  def add_host_to_attending
    self.users_events.create(user: self.creator)
  end
end
