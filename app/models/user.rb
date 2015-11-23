class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: {minimum: 3, maximum: 50}
  validates :address, presence: true, length: {minimum: 5, maximum: 100}

  has_many :reservations
  has_many :items

  def incoming_reservations
    items.map(&:reservations).map(&:not_self_reserved).map(&:all).map(&:to_a).flatten
  end
end
