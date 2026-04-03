require 'rails_helper'

RSpec.describe BrokerFinance, type: :model do
  it 'rejects deposits above the cash price' do
    finance = build(:broker_finance, cash_price: 10_000, deposit: 10_001)

    expect(finance).not_to be_valid
    expect(finance.errors[:deposit]).to include('cannot be greater than the cash price')
  end

  it 'requires the total amount payable to cover the amount financed' do
    finance = build(:broker_finance, amount_to_finance: 12_500, total_amount_payable: 12_499)

    expect(finance).not_to be_valid
    expect(finance.errors[:total_amount_payable]).to include('must be at least the amount to finance')
  end
end
