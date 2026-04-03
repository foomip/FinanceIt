require 'rails_helper'

RSpec.describe 'BrokerHpAgreements', type: :request do
  let(:modern_browser_headers) do
    {
      'HOST' => 'localhost',
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'
    }
  end

  let(:user) { create(:user, :admin) }
  let(:broker_application) { create(:broker_application, :with_details, application_reference: 'AF-2026-00417') }

  around do |example|
    original_value = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = false
    example.run
  ensure
    ActionController::Base.allow_forgery_protection = original_value
  end

  describe 'GET /broker_applications/:broker_application_id/hp_agreement/new' do
    it 'redirects unauthenticated users to sign in' do
      get new_broker_application_hp_agreement_path(broker_application), headers: modern_browser_headers

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'shows the minimal-input agreement step for authenticated users' do
      sign_in user

      get new_broker_application_hp_agreement_path(broker_application), headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Prepare the agreement from the data you already trust.')
      expect(response.body).to include('Adam Piers')
      expect(response.body).to include('Ford Focus ST-Line')
      expect(response.body).to include('Term (months)')
    end
  end

  describe 'POST /broker_applications/:broker_application_id/hp_agreement' do
    before do
      sign_in user
    end

    it 'creates the HP agreement while reusing the broker application snapshot' do
      expect do
        post broker_application_hp_agreement_path(broker_application), params: {
          broker_hp_agreement: {
            term_months: 48,
            first_payment_date: '2026-05-01',
            full_name: 'Ignored Value'
          }
        }, headers: modern_browser_headers
      end.to change(BrokerHpAgreement, :count).by(1)

      expect(response).to redirect_to(broker_application_hp_agreement_path(broker_application))

      agreement = broker_application.reload.broker_hp_agreement

      expect(agreement.full_name).to eq('Adam Piers')
      expect(agreement.term_months).to eq(48)
      expect(agreement.first_payment_date).to eq(Date.new(2026, 5, 1))
    end

    it 're-renders the form when required agreement inputs are missing' do
      post broker_application_hp_agreement_path(broker_application), params: {
        broker_hp_agreement: {
          term_months: '',
          first_payment_date: ''
        }
      }, headers: modern_browser_headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('Please correct the highlighted fields.')
      expect(BrokerHpAgreement.count).to eq(0)
    end
  end

  describe 'GET /broker_applications/:broker_application_id/hp_agreement' do
    it 'redirects to new when the agreement has not been prepared yet' do
      sign_in user

      get broker_application_hp_agreement_path(broker_application), headers: modern_browser_headers

      expect(response).to redirect_to(new_broker_application_hp_agreement_path(broker_application))
    end

    it 'shows the prepared agreement when present' do
      sign_in user
      create(:broker_hp_agreement, broker_application: broker_application)

      get broker_application_hp_agreement_path(broker_application), headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('HP Agreement Prepared')
      expect(response.body).to include('01/05/2026')
    end
  end
end
