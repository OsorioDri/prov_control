class RemoveAcceptanceDateFromEnrollments < ActiveRecord::Migration[7.1]
  def change
    remove_column :enrollments, :date_invitation_accepted, :date
  end
end
