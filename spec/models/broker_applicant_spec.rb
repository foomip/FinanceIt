require 'rails_helper'

RSpec.describe BrokerApplicant, type: :model do
  it 'normalizes the postcode before validation' do
    applicant = build(:broker_applicant, postcode: ' b91 3qr ')

    applicant.validate

    expect(applicant.postcode).to eq('B91 3QR')
  end

  it 'rejects future dates of birth' do
    applicant = build(:broker_applicant, date_of_birth: Date.tomorrow)

    expect(applicant).not_to be_valid
    expect(applicant.errors[:date_of_birth]).to include('must be in the past')
  end
end
