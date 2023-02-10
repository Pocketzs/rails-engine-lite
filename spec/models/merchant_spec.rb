require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'class methods' do
    describe '.find_merchants_by_name' do
      it 'returns merchant matched with name' do
        merchant1 = create(:merchant, name: 'Walmart')
        merchant2 = create(:merchant, name: 'Allmart')

        expect(Merchant.find_merchants_by_name('MaRt')).to eq([merchant2, merchant1])
      end
    end
  end
end