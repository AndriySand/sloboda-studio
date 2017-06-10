class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, index: true
      t.integer :author_id, index: true
      t.text :description
      t.text :content
      t.string :status

      t.timestamps null: false
    end
  end
end
