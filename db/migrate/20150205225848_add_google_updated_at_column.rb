class AddGoogleUpdatedAtColumn < ActiveRecord::Migration
  def change
    add_column :locations, :hours_updated_at, :datetime
  end
end
