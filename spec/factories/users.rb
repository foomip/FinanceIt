FactoryBot.define do
  factory :user do
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              { "password123" }
    password_confirmation { password }
    role                  { User::ROLES[:payout_reviewer] }

    trait :admin do
      role { User::ROLES[:admin] }
    end
  end
end
