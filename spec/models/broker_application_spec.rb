require 'rails_helper'

RSpec.describe BrokerApplication, type: :model do
  it 'is valid with nested broker application details' do
    broker_application = build(:broker_application, :with_details)

    expect(broker_application).to be_valid
  end

  it 'requires an application reference in the expected format' do
    broker_application = build(:broker_application, :with_details, application_reference: 'INVALID')

    expect(broker_application).not_to be_valid
    expect(broker_application.errors[:application_reference]).to include('must use the format AF-YYYY-NNNNN')
  end

  it 'requires applicant, vehicle, and finance details' do
    broker_application = build(:broker_application)

    expect(broker_application).not_to be_valid
    expect(broker_application.errors[:broker_applicant]).to include("can't be blank")
    expect(broker_application.errors[:broker_vehicle]).to include("can't be blank")
    expect(broker_application.errors[:broker_finance]).to include("can't be blank")
  end
end
