FactoryBot.define do
  factory :broker_applicant do
    association :broker_application
    first_name { "Adam" }
    surname { "Piers" }
    date_of_birth { Date.new(1988, 3, 15) }
    address_line_1 { "14 Birchwood Lane" }
    city { "Solihull" }
    postcode { "B91 3QR" }
    employment_status { "full_time" }
    time_at_current_employer_years { 3 }
  end
end
