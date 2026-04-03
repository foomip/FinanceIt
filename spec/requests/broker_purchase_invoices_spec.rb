require 'rails_helper'

RSpec.describe 'BrokerPurchaseInvoices', type: :request do
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

  describe 'GET /broker_applications/:broker_application_id/purchase_invoice/new' do
    it 'redirects unauthenticated users to sign in' do
      get new_broker_application_purchase_invoice_path(broker_application), headers: modern_browser_headers

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'requires the HP agreement to be prepared first' do
      sign_in user

      get new_broker_application_purchase_invoice_path(broker_application), headers: modern_browser_headers

      expect(response).to redirect_to(new_broker_application_hp_agreement_path(broker_application))
    end

    it 'shows the purchase invoice capture step for authenticated users' do
      sign_in user
      create(:broker_hp_agreement, broker_application: broker_application)

      get new_broker_application_purchase_invoice_path(broker_application), headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Capture the dealer invoice as the next document snapshot.')
      expect(response.body).to include('Ford Focus ST-Line')
      expect(response.body).to include('Invoice header')
    end
  end

  describe 'POST /broker_applications/:broker_application_id/purchase_invoice' do
    before do
      sign_in user
      create(:broker_hp_agreement, broker_application: broker_application)
    end

    it 'creates the purchase invoice while preserving invoice-entered values' do
      expect do
        post broker_application_purchase_invoice_path(broker_application), params: {
          broker_purchase_invoice: {
            supplier_name: 'Midland Cars Direct',
            invoice_number: 'MCD-2026-0892',
            invoice_date: '2026-03-19',
            addressed_to: 'Northgate Motor Finance Ltd',
            customer_name: 'A J Piers',
            address_line_1: '14 Birchwood Ln',
            city: 'Solihull',
            postcode: 'B91 3QR',
            make_model: 'Ford Focus ST-Line',
            registration: 'WR21 XYZ',
            mileage_at_sale: 28_400,
            vehicle_price: '14000.00',
            administration_fee: '295.00',
            delivery_charge: '150.00',
            invoice_total: '14445.00',
            finance_company: 'Northgate Motor Finance Ltd',
            vat_note: 'No VAT charged. Seller is not VAT registered.'
          }
        }, headers: modern_browser_headers
      end.to change(BrokerPurchaseInvoice, :count).by(1)

      expect(response).to redirect_to(broker_application_purchase_invoice_path(broker_application))

      invoice = broker_application.reload.broker_purchase_invoice

      expect(invoice.customer_name).to eq('A J Piers')
      expect(invoice.address_line_1).to eq('14 Birchwood Ln')
      expect(invoice.registration).to eq('WR21XYZ')
      expect(invoice.deposit_received).to eq(1_500)
      expect(invoice.amount_to_finance).to eq(12_500)
    end

    it 're-renders the form when required invoice inputs are missing' do
      post broker_application_purchase_invoice_path(broker_application), params: {
        broker_purchase_invoice: {
          supplier_name: '',
          invoice_number: '',
          invoice_date: ''
        }
      }, headers: modern_browser_headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('Please correct the highlighted fields.')
      expect(BrokerPurchaseInvoice.count).to eq(0)
    end
  end

  describe 'GET /broker_applications/:broker_application_id/purchase_invoice' do
    it 'redirects to new when the invoice has not been captured yet' do
      sign_in user
      create(:broker_hp_agreement, broker_application: broker_application)

      get broker_application_purchase_invoice_path(broker_application), headers: modern_browser_headers

      expect(response).to redirect_to(new_broker_application_purchase_invoice_path(broker_application))
    end

    it 'shows the captured invoice when present' do
      sign_in user
      create(:broker_hp_agreement, broker_application: broker_application)
      create(:broker_purchase_invoice, broker_application: broker_application)

      get broker_application_purchase_invoice_path(broker_application), headers: modern_browser_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Purchase Invoice Captured')
      expect(response.body).to include('A J Piers')
      expect(response.body).to include('MCD-2026-0892')
    end
  end
end
