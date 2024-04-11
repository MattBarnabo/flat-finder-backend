class Apartment < ApplicationRecord
  belongs_to :user
  validates :street, :unit, :city, :state, :square_footage, :price, :bedrooms, :pets, :bathrooms, :image, presence: true
end
