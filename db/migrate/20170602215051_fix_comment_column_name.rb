class FixCommentColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :user, :user_name
  end
end
