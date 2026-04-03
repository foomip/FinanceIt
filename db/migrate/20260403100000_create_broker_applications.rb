class CreateBrokerApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :broker_applications do |t|
      t.string :application_reference, null: false

      t.timestamps
    end

    add_index :broker_applications, :application_reference, unique: true
  end
end
