class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.string :short_description
      t.decimal :price
      t.boolean :published
      t.datetime :published_at
      t.integer :category_id
      t.string :level
      t.string :thumbnail_url
      t.integer :duration_minutes

      t.timestamps
    end
  end
end
