class AddAcceptanceDateToEnrollments < ActiveRecord::Migration[7.1]
  def change
    add_column :enrollments, :acceptance_date, :date
  end
end
