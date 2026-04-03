class CreateBrokerHpAgreements < ActiveRecord::Migration[8.1]
  def change
    create_table :broker_hp_agreements do |t|
      t.references :broker_application, null: false, foreign_key: true, index: { unique: true }
      t.string :full_name, null: false
      t.date :date_of_birth, null: false
      t.string :address_line_1, null: false
      t.string :city, null: false
      t.string :postcode, null: false
      t.string :make_model, null: false
      t.integer :vehicle_year, null: false
      t.string :registration, null: false
      t.decimal :cash_price, precision: 10, scale: 2, null: false
      t.decimal :deposit, precision: 10, scale: 2, null: false
      t.decimal :advance_amount, precision: 10, scale: 2, null: false
      t.decimal :monthly_payment, precision: 10, scale: 2, null: false
      t.decimal :total_amount_payable, precision: 10, scale: 2, null: false
      t.decimal :apr, precision: 5, scale: 2, null: false
      t.integer :term_months, null: false
      t.date :first_payment_date, null: false

      t.timestamps
    end

    add_index :broker_hp_agreements, :registration
  end
end
