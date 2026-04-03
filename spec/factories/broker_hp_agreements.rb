FactoryBot.define do
  factory :broker_hp_agreement do
    association :broker_application, :with_details
    term_months { 48 }
    first_payment_date { Date.new(2026, 5, 1) }
  end
end
