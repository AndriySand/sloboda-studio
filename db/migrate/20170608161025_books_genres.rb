class BooksGenres < ActiveRecord::Migration
  def change
    create_table :books_genres, id: false do |t|
      t.integer :book_id
      t.integer :genre_id

      t.timestamps null: false
    end
    add_index :books_genres, [:book_id, :genre_id], unique: true
  end
end
