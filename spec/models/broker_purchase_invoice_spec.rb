require 'rails_helper'

RSpec.describe BrokerPurchaseInvoice, type: :model do
  it 'copies shared values from the broker application before validation' do
    purchase_invoice = described_class.new(
      broker_application: build(:broker_application, :with_details),
      supplier_name: 'Midland Cars Direct',
      invoice_number: 'MCD-2026-0892',
      invoice_date: Date.new(2026, 3, 19),
      addressed_to: 'Northgate Motor Finance Ltd',
      administration_fee: 295,
      delivery_charge: 150,
      invoice_total: 14_445,
      finance_company: 'Northgate Motor Finance Ltd',
      vat_note: 'No VAT charged. Seller is not VAT registered.'
    )

    expect(purchase_invoice).to be_valid
    expect(purchase_invoice.customer_name).to eq('Adam Piers')
    expect(purchase_invoice.registration).to eq('WR21XYZ')
    expect(purchase_invoice.deposit_received).to eq(1_500)
  end

  it 'preserves invoice-entered values while normalizing registration and postcode' do
    purchase_invoice = build(
      :broker_purchase_invoice,
      customer_name: 'A J Piers',
      address_line_1: '14 Birchwood Ln',
      postcode: 'b91 3qr',
      registration: 'WR21 XYZ'
    )

    expect(purchase_invoice).to be_valid
    expect(purchase_invoice.customer_name).to eq('A J Piers')
    expect(purchase_invoice.address_line_1).to eq('14 Birchwood Ln')
    expect(purchase_invoice.postcode).to eq('B91 3QR')
    expect(purchase_invoice.registration).to eq('WR21XYZ')
  end
end
