class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0
  after_destroy :destroy_empty_invoices

  private

  def destroy_empty_invoices
    Invoice.destroy_all
  end
end
