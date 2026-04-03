FactoryBot.define do
  factory :broker_purchase_invoice do
    association :broker_application, :with_details
    supplier_name { 'Midland Cars Direct' }
    invoice_number { 'MCD-2026-0892' }
    invoice_date { Date.new(2026, 3, 19) }
    addressed_to { 'Northgate Motor Finance Ltd' }
    customer_name { 'A J Piers' }
    address_line_1 { '14 Birchwood Ln' }
    city { 'Solihull' }
    postcode { 'B91 3QR' }
    make_model { 'Ford Focus ST-Line' }
    registration { 'WR21 XYZ' }
    mileage_at_sale { 28_400 }
    vehicle_price { 14_000 }
    administration_fee { 295 }
    delivery_charge { 150 }
    invoice_total { 14_445 }
    deposit_received { 1_500 }
    amount_to_finance { 12_500 }
    finance_company { 'Northgate Motor Finance Ltd' }
    vat_note { 'No VAT charged. Seller is not VAT registered.' }
  end
end
