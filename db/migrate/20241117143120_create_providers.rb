class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :cnpj
      t.string :site_url
      t.string :contact_name
      t.date :acceptance_date

      t.timestamps
    end
  end
end
