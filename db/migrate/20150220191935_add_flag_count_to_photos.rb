class AddFlagCountToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :flags, :integer
  end
end
