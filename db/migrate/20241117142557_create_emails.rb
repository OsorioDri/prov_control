class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails do |t|
      t.string :address
      t.references :municipality, null: false, foreign_key: true

      t.timestamps
    end
  end
end
