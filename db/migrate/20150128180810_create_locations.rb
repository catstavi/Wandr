class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.float :long
      t.float :lat
      t.string :desc
      t.boolean :active

      t.timestamps
    end
  end
end
