class CreateWindows < ActiveRecord::Migration
  def change
    create_table :windows do |t|
      t.integer :location_id
      t.string :day
      t.time :open
      t.time :close

      t.timestamps
    end
  end
end
