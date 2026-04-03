FactoryBot.define do
  factory :broker_vehicle do
    association :broker_application
    make_model { "Ford Focus ST-Line" }
    year { 2021 }
    registration { "WR21XYZ" }
    mileage { 27_000 }
  end
end
