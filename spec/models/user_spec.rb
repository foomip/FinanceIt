require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'roles' do
    it 'defaults to payout_reviewer' do
      user = build(:user)

      expect(user).to be_payout_reviewer
    end

    it 'is valid with the admin role' do
      user = build(:user, :admin)

      expect(user).to be_valid
    end

    it 'reports admin users as admin' do
      user = build(:user, :admin)

      expect(user).to be_admin
    end
  end
end
