class CreateBrokerFinances < ActiveRecord::Migration[8.1]
  def change
    create_table :broker_finances do |t|
      t.references :broker_application, null: false, foreign_key: true, index: { unique: true }
      t.decimal :cash_price, precision: 10, scale: 2, null: false
      t.decimal :deposit, precision: 10, scale: 2, null: false
      t.decimal :amount_to_finance, precision: 10, scale: 2, null: false
      t.decimal :monthly_payment, precision: 10, scale: 2, null: false
      t.decimal :total_amount_payable, precision: 10, scale: 2, null: false
      t.decimal :apr, precision: 5, scale: 2, null: false
      t.decimal :glass_guide_retail_estimate, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
