class BrokerApplication < ApplicationRecord
  REFERENCE_FORMAT = /\AAF-\d{4}-\d{5}\z/

  has_one :broker_applicant, dependent: :destroy, inverse_of: :broker_application
  has_one :broker_vehicle, dependent: :destroy, inverse_of: :broker_application
  has_one :broker_finance, dependent: :destroy, inverse_of: :broker_application
  has_one :broker_hp_agreement, dependent: :destroy, inverse_of: :broker_application

  accepts_nested_attributes_for :broker_applicant
  accepts_nested_attributes_for :broker_vehicle
  accepts_nested_attributes_for :broker_finance

  validates :application_reference, presence: true, uniqueness: true,
    format: { with: REFERENCE_FORMAT, message: "must use the format AF-YYYY-NNNNN" }
  validates :broker_applicant, :broker_vehicle, :broker_finance, presence: true

  def applicant_full_name
    [ broker_applicant&.first_name, broker_applicant&.surname ].compact.join(" ")
  end

  def applicant_address
    [ broker_applicant&.address_line_1, broker_applicant&.city, broker_applicant&.postcode ].compact.join(", ")
  end

  def vehicle_label
    [ broker_vehicle&.make_model, broker_vehicle&.registration ].compact.join(" · ")
  end

  def hp_agreement_seed_attributes
    return {} unless broker_applicant && broker_vehicle && broker_finance

    {
      full_name: applicant_full_name,
      date_of_birth: broker_applicant.date_of_birth,
      address_line_1: broker_applicant.address_line_1,
      city: broker_applicant.city,
      postcode: broker_applicant.postcode,
      make_model: broker_vehicle.make_model,
      vehicle_year: broker_vehicle.year,
      registration: broker_vehicle.registration,
      cash_price: broker_finance.cash_price,
      deposit: broker_finance.deposit,
      advance_amount: broker_finance.amount_to_finance,
      monthly_payment: broker_finance.monthly_payment,
      total_amount_payable: broker_finance.total_amount_payable,
      apr: broker_finance.apr
    }
  end
end
