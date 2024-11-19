class CreateBatches < ActiveRecord::Migration[7.1]
  def change
    create_table :batches do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
