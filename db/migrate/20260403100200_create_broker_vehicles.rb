class CreateBrokerVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :broker_vehicles do |t|
      t.references :broker_application, null: false, foreign_key: true, index: { unique: true }
      t.string :make_model, null: false
      t.integer :year, null: false
      t.string :registration, null: false
      t.integer :mileage, null: false

      t.timestamps
    end

    add_index :broker_vehicles, :registration
  end
end
