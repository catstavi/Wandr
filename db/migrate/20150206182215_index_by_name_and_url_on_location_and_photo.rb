class IndexByNameAndUrlOnLocationAndPhoto < ActiveRecord::Migration
  def change
    add_index :locations, :name
    add_index :photos, :url
  end  
end
