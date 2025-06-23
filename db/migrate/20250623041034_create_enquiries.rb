class CreateEnquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :enquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :subject
      t.text :message
      t.timestamps
    end
  end
end
