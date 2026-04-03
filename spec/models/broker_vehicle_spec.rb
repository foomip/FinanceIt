require 'rails_helper'

RSpec.describe BrokerVehicle, type: :model do
  it 'normalizes the registration before validation' do
    vehicle = build(:broker_vehicle, registration: 'wr21 xyz')

    vehicle.validate

    expect(vehicle.registration).to eq('WR21XYZ')
  end

  it 'rejects invalid registrations' do
    vehicle = build(:broker_vehicle, registration: 'WR21-XYZ')

    expect(vehicle).not_to be_valid
    expect(vehicle.errors[:registration]).to include('must contain only letters and numbers')
  end
end
