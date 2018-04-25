class AddCustomerTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :customer_token, :string
  end
end
