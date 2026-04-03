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

      expect(response.body).to include('Payout review, reduced to the work that matters.')
    end

    it 'renders the user role for authenticated users' do
      sign_in user

      get '/', headers: modern_browser_headers

      expect(response.body).to include('Admin')
    end
  end
end
