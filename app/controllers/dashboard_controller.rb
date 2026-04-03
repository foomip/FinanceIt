class DashboardController < ApplicationController
  def index
    @sections = [
      {
        title: "Deal queue",
        summary: "Start with the highest-confidence deals so reviewers spend time only where the engine finds risk or ambiguity.",
        status: "Next"
      },
      {
        title: "Reconciliation workspace",
        summary: "Compare source values, understand mismatches, and confirm whether a discrepancy blocks payout.",
        status: "Planned"
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
