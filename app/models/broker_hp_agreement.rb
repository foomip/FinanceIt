class BrokerHpAgreement < ApplicationRecord
  belongs_to :broker_application, inverse_of: :broker_hp_agreement

  before_validation :apply_broker_application_snapshot
  before_validation :normalize_postcode
  before_validation :normalize_registration

  validates :full_name, :date_of_birth, :address_line_1, :city, :postcode,
    :make_model, :vehicle_year, :registration, :cash_price, :deposit,
    :advance_amount, :monthly_payment, :total_amount_payable, :apr,
    :term_months, :first_payment_date, presence: true
  validates :vehicle_year,
    numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: Date.current.year + 1 }
  validates :cash_price, :deposit, :advance_amount, :monthly_payment, :total_amount_payable,
    numericality: { greater_than_or_equal_to: 0 }
  validates :apr, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :term_months,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 120 }

  def address
    [ address_line_1, city, postcode ].join(", ")
  end

  private

  def apply_broker_application_snapshot
    return unless broker_application

    broker_application.hp_agreement_seed_attributes.each do |attribute, value|
      self[attribute] = value if self[attribute].blank?
    end
  end

  def normalize_postcode
    self.postcode = postcode.to_s.strip.upcase
  end

  def normalize_registration
    self.registration = registration.to_s.upcase.delete(" ")
  end
end
