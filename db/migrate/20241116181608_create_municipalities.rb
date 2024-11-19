class CreateMunicipalities < ActiveRecord::Migration[7.1]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_title
      t.integer :original_coordinator
      # the original coordinator will be a hardcoded second FK to Users table
      #could not find a way to implement this with foreign keys and activerecord associations
      t.integer :number_of_attempts
      t.date :date_last_attempt
      t.boolean :contact_effective
      t.date :official_letter_sent
      t.boolean :capital_city
      t.references :state, null: false, foreign_key: true
      t.references :batch, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      # this FK will represent the current coordinator

      t.timestamps
    end
  end
end
