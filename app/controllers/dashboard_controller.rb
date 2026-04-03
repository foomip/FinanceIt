class DashboardController < ApplicationController
  def index
    @recent_broker_applications = BrokerApplication.includes(:broker_applicant, :broker_vehicle, :broker_hp_agreement, :broker_purchase_invoice)
      .order(created_at: :desc)
      .limit(5)
    @captured_hp_agreements_count = BrokerHpAgreement.count
    @captured_purchase_invoices_count = BrokerPurchaseInvoice.count

    @sections = [
      {
        title: "Broker application capture",
        summary: "Capture the originating deal data in a structured format so later reconciliation stages compare trusted fields instead of raw documents.",
        status: "Live"
      },
      {
        title: "Document snapshots",
        summary: "Reuse the broker application baseline, prepare the HP agreement, and now capture the dealer purchase invoice as a second downstream source for later field reconciliation.",
        status: "Live"
      },
      {
        title: "Exceptions and escalation",
        summary: "Route genuine problems to the right owner with context instead of forcing manual back-and-forth.",
        status: "Planned"
      },
      {
        title: "Audit trail",
        summary: "Capture who reviewed what, when they overrode automation, and why the deal was allowed through.",
        status: "Planned"
      }
    ]
  end
end
