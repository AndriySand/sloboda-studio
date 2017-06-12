class AddPictureToBooks < ActiveRecord::Migration
  def change
    add_attachment :books, :picture
  end
end
