class AddDetailsToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :enrollment_date, :date
    add_column :students, :status, :string
    add_column :students, :parent_guardian_name, :string
    add_column :students, :emergency_contact, :string
    add_column :students, :progress_status, :string
  end
end
