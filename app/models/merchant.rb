class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_merchants_by_name(query)
    raise ActiveRecord::RecordInvalid unless valid_name?(query)
    order(:name).where('name ilike ?', "%#{query}%")
  end

  private

  def self.valid_name?(query)
    return false if query.nil?
    true unless query.empty? || query.match?(/[^a-zA-Z]+/)
  end
end