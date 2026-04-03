class BrokerHpAgreementsController < ApplicationController
  before_action :set_broker_application
  before_action :set_broker_hp_agreement, only: :show

  def new
    if @broker_application.broker_hp_agreement.present?
      redirect_to broker_application_hp_agreement_path(@broker_application), notice: "HP agreement already prepared for this deal."
      return
    end

    @broker_hp_agreement = @broker_application.build_broker_hp_agreement
  end

  def create
    @broker_hp_agreement = @broker_application.broker_hp_agreement || @broker_application.build_broker_hp_agreement
    @broker_hp_agreement.assign_attributes(broker_hp_agreement_params)

    if @broker_hp_agreement.save
      redirect_to broker_application_hp_agreement_path(@broker_application), notice: "HP agreement prepared successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def show; end

  private

  def set_broker_application
    @broker_application = BrokerApplication.includes(:broker_applicant, :broker_vehicle, :broker_finance, :broker_hp_agreement).find(params[:broker_application_id])
  end

  def set_broker_hp_agreement
    @broker_hp_agreement = @broker_application.broker_hp_agreement
    return if @broker_hp_agreement.present?

    redirect_to new_broker_application_hp_agreement_path(@broker_application), alert: "Prepare the HP agreement before viewing it."
  end

  def broker_hp_agreement_params
    params.require(:broker_hp_agreement).permit(:term_months, :first_payment_date)
  end
end
