class DashboardController < ApplicationController
  def index
    @recent_broker_applications = BrokerApplication.includes(:broker_applicant, :broker_vehicle, :broker_hp_agreement)
      .order(created_at: :desc)
      .limit(5)
    @captured_hp_agreements_count = BrokerHpAgreement.count

    @sections = [
      {
        title: "Broker application capture",
        summary: "Capture the originating deal data in a structured format so later reconciliation stages compare trusted fields instead of raw documents.",
        status: "Live"
      },
      {
        title: "Reconciliation workspace",
        summary: "Reuse the broker application as the baseline, add HP agreement details without re-keying shared fields, and prepare the deal for field-by-field checks.",
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
