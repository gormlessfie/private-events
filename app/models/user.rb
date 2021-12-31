class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true, length: { in: 3..12 }

  has_many :events, dependent: :destroy

  has_many :users_events, dependent: :destroy
  has_many :attended_events, through: :users_events, source: :event
end
