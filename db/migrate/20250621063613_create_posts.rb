class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :excerpt
      t.datetime :published_at
      t.string :status
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
