class RemoveHasHoursColumn < ActiveRecord::Migration
  def change
    remove_column :locations, :has_hours
  end
end
