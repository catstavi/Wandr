class AddHasHoursBoolToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :has_hours, :boolean
  end
end
