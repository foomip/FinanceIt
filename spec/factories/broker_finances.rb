FactoryBot.define do
  factory :broker_finance do
    association :broker_application
    cash_price { 14_000.00 }
    deposit { 1_500.00 }
    amount_to_finance { 12_500.00 }
    monthly_payment { 287.43 }
    total_amount_payable { 17_245.80 }
    apr { 9.9 }
    glass_guide_retail_estimate { 14_200.00 }
  end
end
