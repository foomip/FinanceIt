class BrokerFinance < ApplicationRecord
  belongs_to :broker_application, inverse_of: :broker_finance

  validates :cash_price, :deposit, :amount_to_finance, :monthly_payment,
    :total_amount_payable, :apr, :glass_guide_retail_estimate, presence: true
  validates :cash_price, :deposit, :amount_to_finance, :monthly_payment,
    :total_amount_payable, :glass_guide_retail_estimate,
    numericality: { greater_than_or_equal_to: 0 }
  validates :apr, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :deposit_not_greater_than_cash_price
  validate :amount_to_finance_not_greater_than_cash_price
  validate :total_amount_payable_not_less_than_amount_to_finance

  private

  def deposit_not_greater_than_cash_price
    return if deposit.blank? || cash_price.blank?

    errors.add(:deposit, "cannot be greater than the cash price") if deposit > cash_price
  end

  def amount_to_finance_not_greater_than_cash_price
    return if amount_to_finance.blank? || cash_price.blank?

    errors.add(:amount_to_finance, "cannot be greater than the cash price") if amount_to_finance > cash_price
  end

  def total_amount_payable_not_less_than_amount_to_finance
    return if total_amount_payable.blank? || amount_to_finance.blank?

    if total_amount_payable < amount_to_finance
      errors.add(:total_amount_payable, "must be at least the amount to finance")
    end
  end
end
