class AddForeignKeyUserToMunicipalities < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :municipalities, :users, column: :original_coordinator, null: false, foreign_key: true
    add_foreign_key :municipalities, :users, column: :current_coordinator, null: false, foreign_key: true
  end
end
