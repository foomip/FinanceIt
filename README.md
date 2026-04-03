# InsureIt

InsureIt is a Rails prototype for an internal motor finance reconciliation tool. The product goal is to reduce payout administration work by automatically comparing the key fields across deal documents and surfacing only the deals that need human attention.

## Jobs To Be Done

**Primary users**

- Payout reviewers who need to clear straightforward deals quickly and investigate genuine mismatches.
- Team leads or admins who need visibility into workflow health, escalations, and override decisions.

**Core jobs**

- Understand whether a deal can move forward without a manual document-by-document review.
- See exactly which fields mismatch, which source documents disagree, and whether the issue is blocking.
- Route exceptions to the right person with enough context to resolve them without repeated back-and-forth.
- Keep a defensible audit trail for every automated pass, manual review, and override.

## What This Slice Builds

This step focuses on broker application capture, which is the first structured input into the reconciliation workflow.

- Devise authentication for internal users.
- Initial user roles: `payout_reviewer` and `admin`.
- A broker application capture flow covering applicant, vehicle, and finance details.
- A dashboard that launches the intake workflow and surfaces recently captured applications.
- A structured deal baseline that later reconciliation screens can compare against other documents.

## Proposed App Sections

1. **Deal queue**
	The operational starting point. Reviewers should see which deals can be auto-cleared, which ones need attention, and what to pick up next.
2. **Reconciliation workspace**
	The main deal screen. It should show normalized field groups, document sources, mismatches, confidence, and the decision path.
3. **Exceptions and escalation**
	A focused flow for the minority of deals with genuine problems, including ownership, comments, and outbound follow-up.
4. **Audit trail**
	A chronological record of system decisions, reviewer actions, and final payout outcomes.

## What I Deliberately Left Out

- Document parsing and OCR.
- Automated extraction from uploaded PDFs or scanned documents.
- The field reconciliation engine itself.
- FCA, HPI, and bank check integrations.
- Editing, workflow states, and approval actions after initial capture.
- A full permissions matrix beyond the initial role split.
- Broker or dealer-facing workflows.

These are the next high-value layers, but they depend on first having a reliable way to capture the originating broker submission as normalized data.

## If I Had More Time

1. Implement the reconciliation workspace for one representative deal using the provided source documents.
2. Add document upload or ingestion so the broker application can be compared directly against the HP agreement, invoice, and mandate.
3. Build reviewer actions for approve, hold, and escalate with an audit timeline.
4. Introduce Pundit policies and tighter account provisioning once the user journeys are clearer.

## Local Setup

```bash
docker compose run --rm app bin/setup
docker compose run --rm app bin/rails db:seed
docker compose up -d
```

Open `http://localhost:3000` and sign in with one of the seeded users:

- `admin@insureit.local` / `password123`
- `reviewer@insureit.local` / `password123`

## Verification

```bash
docker compose run --rm app rspec
docker compose run --rm app bin/rubocop
docker compose run --rm app bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error
docker compose run --rm app bin/bundler-audit
```

## Current Status

The repo currently implements authentication, roles, broker application capture, and a dashboard entry point into that workflow. The reconciliation engine, document comparisons, exception handling, and operational decisioning tools are still to be built in the next steps.
