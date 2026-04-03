require 'rails_helper'

RSpec.describe BrokerHpAgreement, type: :model do
  it 'copies the broker application snapshot before validation' do
    agreement = build(:broker_hp_agreement)

    expect(agreement).to be_valid
    expect(agreement.full_name).to eq('Adam Piers')
    expect(agreement.registration).to eq('WR21XYZ')
    expect(agreement.advance_amount).to eq(12_500)
  end

  it 'requires a positive term length' do
    agreement = build(:broker_hp_agreement, term_months: 0)

    expect(agreement).not_to be_valid
    expect(agreement.errors[:term_months]).to include('must be greater than or equal to 1')
  end
end
