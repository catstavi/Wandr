class ChangeReviewsToText < ActiveRecord::Migration
  def change
    change_column :locations, :desc, :text
  end
end
