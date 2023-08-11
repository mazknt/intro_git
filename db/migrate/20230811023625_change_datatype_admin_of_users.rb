class ChangeDatatypeAdminOfUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :admin, :boolean
  end
end
