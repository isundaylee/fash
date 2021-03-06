class Item < ActiveRecord::Base
  GENDER_OPTIONS = [['Male', 'male'], ['Female', 'female'], ['Unisex', 'unisex']]
  SIZE_OPTIONS = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL']
  CATEGORY_OPTIONS = ['Dress Shirt', 'T-Shirt', 'Pant', 'Suit', 'Tuxedo']
  COLOR_OPTIONS = ['Crimson', 'Aqua', 'White', 'Black']
  PRICE_RANGE_OPTIONS = [
    ['$1-$5', '1-5'],
    ['$5-$10', '5-10'],
    ['$10-$20', '10-20'],
    ['$20-$50', '20-50'],
    ['$50-$100', '50-100']
  ]

  enum gender: [:male, :female, :unisex]

  belongs_to :user

  has_many :previews
  has_many :reservations

  validates :size, presence: true, inclusion: SIZE_OPTIONS
  validates :gender, presence: true
  validates :category, presence: true, inclusion: CATEGORY_OPTIONS
  validates :price, presence: true, numericality: {minimum: 1.0}
  validates :insurance_claim, presence: true, numericality: {minimum: 1.0}
  validates :color, presence: true

  def available_on?(date)
    !reservations.select { |r| r.start_date <= date && date <= r.end_date }.select(&:blocking?).any?
  end
end
