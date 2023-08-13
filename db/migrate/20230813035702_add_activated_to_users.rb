class AddActivatedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activation_digest, :string
  end
end
