class CreateInstaCodes < ActiveRecord::Migration
  def change
    create_table :insta_codes do |t|
      t.string :code
      t.integer :location_id

      t.timestamps
    end
  end
end
