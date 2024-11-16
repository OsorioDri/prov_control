class CreateMunicipalities < ActiveRecord::Migration[7.1]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_title
      t.integer :original_coordinator
      t.integer :current_coordinator
      t.integer :number_of_attempts
      t.date :date_last_attempt
      t.boolean :contact_effective
      t.date :official_letter_sent
      t.boolean :capital_city
      t.references :state, null: false, foreign_key: true
      t.references :batch, null: true, foreign_key: true
      # t.references :user, column: :original_coordinator, null: false, foreign_key: true
      # t.references :user, column: :current_coordinator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
