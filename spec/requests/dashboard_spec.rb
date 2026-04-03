require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  let(:modern_browser_headers) do
    {
      'HOST' => 'localhost',
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'
    }
  end

  let(:user) { create(:user, :admin) }

  describe 'GET /' do
    it 'redirects unauthenticated users to sign in' do
      get '/', headers: modern_browser_headers

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns ok for authenticated users' do
      sign_in user

      get '/', headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
    end

    it 'renders the dashboard headline for authenticated users' do
      sign_in user

      get '/', headers: modern_browser_headers

      expect(response.body).to include('Start with structured intake, then automate everything after it.')
    end

    it 'renders the user role for authenticated users' do
      sign_in user

      get '/', headers: modern_browser_headers

      expect(response.body).to include('Admin')
    end

    it 'links users to broker application capture' do
      sign_in user

      get '/', headers: modern_browser_headers

      expect(response.body).to include('Capture broker application')
      expect(response.body).to include('Broker application capture')
    end

    it 'shows recent broker applications when present' do
      sign_in user
      create(:broker_application, :with_details, application_reference: 'AF-2026-00417')

      get '/', headers: modern_browser_headers

      expect(response.body).to include('AF-2026-00417')
      expect(response.body).to include('Adam Piers')
    end
  end
end
