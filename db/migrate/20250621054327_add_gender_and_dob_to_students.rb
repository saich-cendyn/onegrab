class AddGenderAndDobToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :gender, :string, null: false
    add_column :students, :dob, :date, null: false
  end
end
