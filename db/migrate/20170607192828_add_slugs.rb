class AddSlugs < ActiveRecord::Migration[5.0]
  def change
    add_column :boards, :slug, :string
    add_column :cards, :slug, :string
  end
end
