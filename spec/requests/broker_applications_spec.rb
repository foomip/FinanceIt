require 'rails_helper'

RSpec.describe 'BrokerApplications', type: :request do
  let(:modern_browser_headers) do
    {
      'HOST' => 'localhost',
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'
    }
  end

  let(:user) { create(:user, :admin) }

  around do |example|
    original_value = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = false
    example.run
  ensure
    ActionController::Base.allow_forgery_protection = original_value
  end

  describe 'GET /broker_applications/new' do
    it 'redirects unauthenticated users to sign in' do
      get new_broker_application_path, headers: modern_browser_headers

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'renders the broker application form for authenticated users' do
      sign_in user

      get new_broker_application_path, headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Capture the originating application before reconciliation starts.')
    end
  end

  describe 'POST /broker_applications' do
    before do
      sign_in user
    end

    it 'captures a broker application with nested details' do
      expect do
        post broker_applications_path, params: {
          broker_application: {
            application_reference: 'AF-2026-00417',
            broker_applicant_attributes: {
              first_name: 'Adam',
              surname: 'Piers',
              date_of_birth: '1988-03-15',
              address_line_1: '14 Birchwood Lane',
              city: 'Solihull',
              postcode: 'B91 3QR',
              employment_status: 'full_time',
              time_at_current_employer_years: 3
            },
            broker_vehicle_attributes: {
              make_model: 'Ford Focus ST-Line',
              year: 2021,
              registration: 'WR21XYZ',
              mileage: 27_000
            },
            broker_finance_attributes: {
              cash_price: '14000.00',
              deposit: '1500.00',
              amount_to_finance: '12500.00',
              monthly_payment: '287.43',
              total_amount_payable: '17245.80',
              apr: '9.9',
              glass_guide_retail_estimate: '14200.00'
            }
          }
        }, headers: modern_browser_headers
      end.to change(BrokerApplication, :count).by(1)
        .and change(BrokerApplicant, :count).by(1)
        .and change(BrokerVehicle, :count).by(1)
        .and change(BrokerFinance, :count).by(1)

      broker_application = BrokerApplication.last

      expect(response).to redirect_to(broker_application_path(broker_application))
      get broker_application_path(broker_application), headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Broker Application Captured')
      expect(response.body).to include('Adam Piers')
      expect(response.body).to include('Start HP agreement')
    end

    it 're-renders the form when nested values are invalid' do
      post broker_applications_path, params: {
        broker_application: {
          application_reference: 'AF-2026-00417',
          broker_applicant_attributes: {
            first_name: '',
            surname: 'Piers',
            date_of_birth: '1988-03-15',
            address_line_1: '14 Birchwood Lane',
            city: 'Solihull',
            postcode: 'B91 3QR',
            employment_status: 'full_time',
            time_at_current_employer_years: 3
          },
          broker_vehicle_attributes: {
            make_model: 'Ford Focus ST-Line',
            year: 2021,
            registration: 'WR21XYZ',
            mileage: 27_000
          },
          broker_finance_attributes: {
            cash_price: '14000.00',
            deposit: '1500.00',
            amount_to_finance: '12500.00',
            monthly_payment: '287.43',
            total_amount_payable: '17245.80',
            apr: '9.9',
            glass_guide_retail_estimate: '14200.00'
          },
          ignored_param: 'should not persist'
        }
      }, headers: modern_browser_headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('Please correct the highlighted fields.')
      expect(BrokerApplication.count).to eq(0)
    end
  end
end
