FactoryBot.define do
  factory :broker_application do
    sequence(:application_reference) { |n| format("AF-2026-%05d", n) }

    trait :with_details do
      after(:build) do |broker_application|
        broker_application.broker_applicant ||= build(:broker_applicant, broker_application: broker_application)
        broker_application.broker_vehicle ||= build(:broker_vehicle, broker_application: broker_application)
        broker_application.broker_finance ||= build(:broker_finance, broker_application: broker_application)
      end
    end
  end
end
