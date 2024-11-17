class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.date :contact_date
      t.boolean :invited
      t.date :date_invitation_accepted
      t.text :note
      t.references :municipality, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
