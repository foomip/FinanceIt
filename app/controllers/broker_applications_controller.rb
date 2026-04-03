class BrokerApplicationsController < ApplicationController
  before_action :set_broker_application, only: :show

  def new
    @broker_application = BrokerApplication.new(application_reference: "AF-2026-00417")
    build_nested_records
  end

  def create
    @broker_application = BrokerApplication.new(broker_application_params)
    build_nested_records

    if @broker_application.save
      redirect_to @broker_application, notice: "Broker application captured successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def show; end

  private

  def set_broker_application
    @broker_application = BrokerApplication.includes(:broker_applicant, :broker_vehicle, :broker_finance).find(params[:id])
  end

  def build_nested_records
    @broker_application.build_broker_applicant unless @broker_application.broker_applicant
    @broker_application.build_broker_vehicle unless @broker_application.broker_vehicle
    @broker_application.build_broker_finance unless @broker_application.broker_finance
  end

  def broker_application_params
    params.require(:broker_application).permit(
      :application_reference,
      broker_applicant_attributes: [
        :first_name,
        :surname,
        :date_of_birth,
        :address_line_1,
        :city,
        :postcode,
        :employment_status,
        :time_at_current_employer_years
      ],
      broker_vehicle_attributes: [
        :make_model,
        :year,
        :registration,
        :mileage
      ],
      broker_finance_attributes: [
        :cash_price,
        :deposit,
        :amount_to_finance,
        :monthly_payment,
        :total_amount_payable,
        :apr,
        :glass_guide_retail_estimate
      ]
    )
  end
end
