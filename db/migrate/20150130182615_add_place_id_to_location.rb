class AddPlaceIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :place_id, :string
  end
end
