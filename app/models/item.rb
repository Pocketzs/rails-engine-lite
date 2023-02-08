class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0
end
