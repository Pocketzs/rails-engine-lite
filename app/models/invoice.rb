class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  before_destroy :invoice_no_items_check, prepend: true

  private

  def invoice_no_items_check
    throw :abort if items.any?
  end
end
