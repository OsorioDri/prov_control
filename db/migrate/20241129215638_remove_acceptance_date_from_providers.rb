class RemoveAcceptanceDateFromProviders < ActiveRecord::Migration[7.1]
  def change
    remove_column :providers, :acceptance_date, :date
  end
end
