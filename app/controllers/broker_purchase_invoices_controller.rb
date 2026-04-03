class BrokerPurchaseInvoicesController < ApplicationController
  before_action :set_broker_application
  before_action :ensure_hp_agreement_prepared
  before_action :set_broker_purchase_invoice, only: :show

  def new
    if @broker_application.broker_purchase_invoice.present?
      redirect_to broker_application_purchase_invoice_path(@broker_application), notice: 'Purchase invoice already captured for this deal.'
      return
    end

    @broker_purchase_invoice = @broker_application.build_broker_purchase_invoice
  end

  def create
    @broker_purchase_invoice = @broker_application.broker_purchase_invoice || @broker_application.build_broker_purchase_invoice
    @broker_purchase_invoice.assign_attributes(broker_purchase_invoice_params)

    if @broker_purchase_invoice.save
      redirect_to broker_application_purchase_invoice_path(@broker_application), notice: 'Purchase invoice captured successfully.'
    else
      render :new, status: :unprocessable_content
    end
  end

  def show; end

  private

  def set_broker_application
    @broker_application = BrokerApplication.includes(:broker_applicant, :broker_vehicle, :broker_finance, :broker_hp_agreement, :broker_purchase_invoice).find(params[:broker_application_id])
  end

  def ensure_hp_agreement_prepared
    return if @broker_application.broker_hp_agreement.present?

    redirect_to new_broker_application_hp_agreement_path(@broker_application), alert: 'Prepare the HP agreement before capturing the purchase invoice.'
  end

  def set_broker_purchase_invoice
    @broker_purchase_invoice = @broker_application.broker_purchase_invoice
    return if @broker_purchase_invoice.present?

    redirect_to new_broker_application_purchase_invoice_path(@broker_application), alert: 'Capture the purchase invoice before viewing it.'
  end

  def broker_purchase_invoice_params
    params.require(:broker_purchase_invoice).permit(
      :invoice_number,
      :invoice_date,
      :supplier_name,
      :addressed_to,
      :customer_name,
      :address_line_1,
      :city,
      :postcode,
      :make_model,
      :registration,
      :mileage_at_sale,
      :vehicle_price,
      :administration_fee,
      :delivery_charge,
      :invoice_total,
      :deposit_received,
      :amount_to_finance,
      :finance_company,
      :vat_note
    )
  end
end
