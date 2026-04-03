class CreateBrokerApplicants < ActiveRecord::Migration[8.1]
  def change
    create_table :broker_applicants do |t|
      t.references :broker_application, null: false, foreign_key: true, index: { unique: true }
      t.string :first_name, null: false
      t.string :surname, null: false
      t.date :date_of_birth, null: false
      t.string :address_line_1, null: false
      t.string :city, null: false
      t.string :postcode, null: false
      t.string :employment_status, null: false
      t.integer :time_at_current_employer_years, null: false

      t.timestamps
    end
  end
end
