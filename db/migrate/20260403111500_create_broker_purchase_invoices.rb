class CreateBrokerPurchaseInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :broker_purchase_invoices do |t|
      t.references :broker_application, null: false, foreign_key: true, index: { unique: true }
      t.string :supplier_name, null: false
      t.string :invoice_number, null: false
      t.date :invoice_date, null: false
      t.string :addressed_to, null: false
      t.string :customer_name, null: false
      t.string :address_line_1, null: false
      t.string :city, null: false
      t.string :postcode, null: false
      t.string :make_model, null: false
      t.string :registration, null: false
      t.integer :mileage_at_sale, null: false
      t.decimal :vehicle_price, precision: 10, scale: 2, null: false
      t.decimal :administration_fee, precision: 10, scale: 2, null: false
      t.decimal :delivery_charge, precision: 10, scale: 2, null: false
      t.decimal :invoice_total, precision: 10, scale: 2, null: false
      t.decimal :deposit_received, precision: 10, scale: 2, null: false
      t.decimal :amount_to_finance, precision: 10, scale: 2, null: false
      t.string :finance_company, null: false
      t.string :vat_note, null: false

      t.timestamps
    end

    add_index :broker_purchase_invoices, :registration
  end
end
