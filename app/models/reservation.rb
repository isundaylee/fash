class Reservation < ActiveRecord::Base
  include AASM

  scope :not_self_reserved, -> { where(self_reserved: false) }

  acts_as_paranoid

  belongs_to :user
  belongs_to :item

  enum state: [:pending_approval, :approved, :paid, :cancelled, :rejected]

  aasm column: :state do
    state :pending_approval, initial: true
    state :approved
    state :paid
    state :cancelled
    state :rejected

    event :approve do
      transitions from: :pending_approval, to: :approved
    end

    event :reject do
      transitions from: :pending_approval, to: :rejected
    end

    event :pay do
      transitions from: :approved, to: :paid
    end

    event :cancel do
      transitions from: [:approved, :pending_approval], to: :cancelled
    end
  end

  def price
    item.price * (end_date - start_date + 1)
  end

  def blocking?
    !(cancelled? || rejected?)
  end
end
