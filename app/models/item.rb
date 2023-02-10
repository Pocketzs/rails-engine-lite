class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0
  after_destroy :destroy_empty_invoices

  def self.find_item_by_name(query)
    raise ActiveRecord::RecordInvalid unless valid_name?(query)
    order(:name).find_by('name ilike ?', "%#{query}%")
  end

  def self.find_item_by_unit_price(min = nil, max = nil)
    raise ActiveRecord::RecordInvalid if invalid_prices?(min, max)
    min = Float::INFINITY if min.nil?
    max = Float::INFINITY if max.nil?
    order(:name).find_by(unit_price: min.to_f..max.to_f)
  end

  private

  def destroy_empty_invoices
    Invoice.destroy_all
  end

  def self.valid_name?(query)
    true unless query.empty? || query.match?(/[^a-zA-Z]+/)
  end

  def self.invalid_prices?(min, max)
    unless min.nil? || max.nil?
      return true if min.to_f > max.to_f
    end
    min.to_f < 0 || max.to_f < 0 || min == "" || max == ""
  end
end
