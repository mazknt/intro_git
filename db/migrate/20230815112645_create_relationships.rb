class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :following_id
      t.integer :follower_id
      t.timestamps
    end
    add_index :relationships, :following_id
    add_index :relationships, :follower_index
    add_index :relationships, [:following_id, :follower_id], unique: true
  end
end
