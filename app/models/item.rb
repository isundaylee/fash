class Item < ActiveRecord::Base
  GENDER_OPTIONS = [['Male', 'male'], ['Female', 'female'], ['Unisex', 'unisex']]
  SIZE_OPTIONS = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL']
  CATEGORY_OPTIONS = ['Dress Shirt', 'T-Shirt', 'Pant', 'Suit', 'Tuxedo']
  COLOR_OPTIONS = ['Crimson', 'Aqua', 'White', 'Black']

  enum gender: [:male, :female, :unisex]

  belongs_to :user

  has_many :previews

  validates :size, presence: true, inclusion: SIZE_OPTIONS
  validates :gender, presence: true
  validates :category, presence: true, inclusion: CATEGORY_OPTIONS
  validates :price, presence: true, numericality: {minimum: 1.0}
  validates :insurance_claim, presence: true, numericality: {minimum: 1.0}
  validates :color, presence: true
end
