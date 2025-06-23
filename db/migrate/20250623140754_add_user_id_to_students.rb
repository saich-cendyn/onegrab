class AddUserIdToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :user_id, :bigint, null: true
  end
end
