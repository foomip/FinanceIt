require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'roles' do
    it 'defaults to payout_reviewer' do
      user = described_class.create!(
        email: 'reviewer@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(user).to be_payout_reviewer
    end

    it 'allows admin users' do
      user = described_class.new(
        email: 'admin@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        role: :admin
      )

      expect(user).to be_valid
      expect(user).to be_admin
    end
  end
end
