class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0
  after_destroy :destroy_empty_invoices

  def self.find_item_by_name(query)
    # where('lower(name) like ?', "%#{query.downcase}%").order(:name).limit(1).first
    raise ActiveRecord::RecordInvalid unless is_valid_string?(query)
    # Item.order(:name).find_by!('lower(name) like ?', "%#{query.downcase}%")
    Item.order(:name).find_by!('name ilike ?', "%#{query}%")
  end

  private

  def destroy_empty_invoices
    Invoice.destroy_all
  end

  def self.is_valid_string?(query)
    return false if query.nil?
    true unless query.empty? || query.match?(/[^a-zA-Z]+/)
    # require 'pry'; binding.pry
  end
end
