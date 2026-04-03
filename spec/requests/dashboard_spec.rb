require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  let(:modern_browser_headers) do
    {
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'
    }
  end

  describe 'GET /' do
    it 'redirects unauthenticated users to sign in' do
      get '/', headers: modern_browser_headers

      expect(response).to redirect_to('/users/sign_in')
    end

    it 'renders the dashboard for authenticated users' do
      user = User.create!(
        email: 'signed-in@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        role: :admin
      )

      sign_in user

      get '/', headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Payout review, reduced to the work that matters.')
      expect(response.body).to include('Admin')
    end
  end
end
