class AssociatePicturesWithActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :picture_id, :integer
  end
end
