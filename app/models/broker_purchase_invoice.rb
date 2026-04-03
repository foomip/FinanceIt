class BrokerPurchaseInvoice < ApplicationRecord
  belongs_to :broker_application, inverse_of: :broker_purchase_invoice

  before_validation :apply_broker_application_defaults
  before_validation :normalize_postcode
  before_validation :normalize_registration

  validates :invoice_number, :invoice_date, :supplier_name, :addressed_to,
    :customer_name, :address_line_1, :city, :postcode, :make_model,
    :registration, :mileage_at_sale, :vehicle_price, :administration_fee,
    :delivery_charge, :invoice_total, :deposit_received, :amount_to_finance,
    :finance_company, :vat_note, presence: true
  validates :invoice_date, comparison: { less_than_or_equal_to: ->(_) { Date.current } }
  validates :mileage_at_sale,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :vehicle_price, :administration_fee, :delivery_charge, :invoice_total,
    :deposit_received, :amount_to_finance, numericality: { greater_than_or_equal_to: 0 }

  def customer_address
    [address_line_1, city, postcode].join(', ')
  end

  private

  def apply_broker_application_defaults
    return unless broker_application

    broker_application.purchase_invoice_default_attributes.each do |attribute, value|
      self[attribute] = value if self[attribute].blank?
    end
  end

  def normalize_postcode
    self.postcode = postcode.to_s.strip.upcase
  end

  def normalize_registration
    self.registration = registration.to_s.upcase.delete(' ')
  end
end
