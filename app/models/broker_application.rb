class BrokerApplication < ApplicationRecord
  REFERENCE_FORMAT = /\AAF-\d{4}-\d{5}\z/

  has_one :broker_applicant, dependent: :destroy, inverse_of: :broker_application
  has_one :broker_vehicle, dependent: :destroy, inverse_of: :broker_application
  has_one :broker_finance, dependent: :destroy, inverse_of: :broker_application

  accepts_nested_attributes_for :broker_applicant
  accepts_nested_attributes_for :broker_vehicle
  accepts_nested_attributes_for :broker_finance

  validates :application_reference, presence: true, uniqueness: true,
    format: { with: REFERENCE_FORMAT, message: "must use the format AF-YYYY-NNNNN" }
  validates :broker_applicant, :broker_vehicle, :broker_finance, presence: true
end
