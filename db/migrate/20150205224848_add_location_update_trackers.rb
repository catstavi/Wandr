class AddLocationUpdateTrackers < ActiveRecord::Migration
  def change
    add_column :locations, :insta_codes_updated_at, :datetime
    add_column :locations, :photos_updated_at, :datetime
  end
end
