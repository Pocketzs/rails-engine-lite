require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent :destroy }
    it { should have_many(:invoices).through :invoice_items }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
  end

  describe 'callback methods' do
    describe 'after_destroy' do
      it 'triggers destroy_empty_invoices after destroy' do
        item = create(:item)
        expect(item).to receive(:destroy_empty_invoices)
        item.destroy
      end
    end

    describe '#destroy_empty_invoices' do
      it 'destroys invoices that have no items' do
        no_items = create(:invoice)
        has_items = create(:invoice)
        item1 = create(:item)
        create(:invoice_item, invoice: has_items, item: item1)

        expect(Invoice.count).to eq(2)

        item1.send(:destroy_empty_invoices)

        expect(Invoice.count).to eq(1)
        expect(Invoice.all).to include(has_items)
        expect(Invoice.all).to_not include(no_items)
      end
    end
  end
end
