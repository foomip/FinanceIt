class User < ApplicationRecord
  ROLES = {
    payout_reviewer: 0,
    admin: 1
  }.freeze

  attribute :role, :integer, default: ROLES[:payout_reviewer]

  validates :role, inclusion: { in: ROLES.values }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def role=(value)
    mapped_value = case value
    when Symbol
      ROLES.fetch(value)
    when String
      ROLES.fetch(value.to_sym, value)
    else
      value
    end

    super(mapped_value)
  end

  def role_name
    ROLES.key(self[:role]).to_s
  end

  def payout_reviewer?
    self[:role] == ROLES[:payout_reviewer]
  end

  def admin?
    self[:role] == ROLES[:admin]
  end
end
