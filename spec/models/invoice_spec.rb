require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:items).through :invoice_items }
  end

  describe 'callback methods' do
    describe 'before_destroy' do
      it 'triggers destroy_empty_invoices after destroy' do
        invoice = create(:invoice)
        expect(invoice).to receive(:invoice_no_items_check)
        invoice.destroy
      end
    end

    describe '#invoice_no_items_check' do
      it 'throws abort if the invoice has any items' do
        invoice = create(:invoice)
        create(:invoice_item, invoice: invoice)

        invoice.destroy

        expect(invoice).to_not be_destroyed
      end
    end
  end
end
