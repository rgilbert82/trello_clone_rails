class RenameCommentBody < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :comment, :body
  end
end
