class BrokerApplicant < ApplicationRecord
  EMPLOYMENT_STATUSES = %w[
    full_time
    part_time
    self_employed
    contract
    unemployed
    retired
    student
  ].freeze

  belongs_to :broker_application, inverse_of: :broker_applicant

  before_validation :normalize_postcode

  validates :first_name, :surname, :date_of_birth, :address_line_1, :city, :postcode,
    :employment_status, presence: true
  validates :employment_status, inclusion: { in: EMPLOYMENT_STATUSES }
  validates :time_at_current_employer_years,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 80 }
  validate :date_of_birth_in_the_past

  def employment_status_label
    employment_status.to_s.humanize
  end

  private

  def normalize_postcode
    self.postcode = postcode.to_s.strip.upcase
  end

  def date_of_birth_in_the_past
    return if date_of_birth.blank?

    errors.add(:date_of_birth, "must be in the past") if date_of_birth >= Date.current
  end
end
