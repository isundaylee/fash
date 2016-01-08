class Reservation < ActiveRecord::Base
  include AASM

  scope :not_self_reserved, -> { where(self_reserved: false) }

  acts_as_paranoid

  belongs_to :user
  belongs_to :item

  enum state: [
    :pending_approval,
    :approved,
    :paid,
    :cancelled,
    :rejected,
    :pickup_scheduled,
    :picked_up,
    :delivery_scheduled,
    :delivered
  ]

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

    event :schedule_pickup do
      transitions from: :paid, to: :pickup_scheduled
    end

    event :pickup do
      transitions from: :pickup_scheduled, to: :picked_up
    end

    event :schedule_delivery do
      transitions from: :picked_up, to: :delivery_scheduled
    end

    event :deliver do
      transitions from: :delivery_scheduled, to: :delivered
    end
  end

  def price
    item.price * (end_date - start_date + 1)
  end

  def blocking?
    !(cancelled? || rejected?)
  end
end
