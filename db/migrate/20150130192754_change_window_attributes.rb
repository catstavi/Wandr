class ChangeWindowAttributes < ActiveRecord::Migration
  def change
    remove_column :windows, :day
    remove_column :windows, :open
    remove_column :windows, :close
    add_column :windows, :open_day, :int
    add_column :windows, :close_day, :int
    add_column :windows, :open_time, :int
    add_column :windows, :close_time, :int

  end
end
