class AddLinkUrlstoLocation < ActiveRecord::Migration
  def change
    add_column :locations, :yelp_link, :string
    add_column :locations, :google_link, :string
  end
end
