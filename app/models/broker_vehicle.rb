class BrokerVehicle < ApplicationRecord
  REGISTRATION_FORMAT = /\A[A-Z0-9]{2,8}\z/

  belongs_to :broker_application, inverse_of: :broker_vehicle

  before_validation :normalize_registration

  validates :make_model, :registration, presence: true
  validates :year,
    numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: Date.current.year + 1 }
  validates :registration,
    format: { with: REGISTRATION_FORMAT, message: "must contain only letters and numbers" }
  validates :mileage,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 500_000 }

  private

  def normalize_registration
    self.registration = registration.to_s.upcase.delete(" ")
  end
end
