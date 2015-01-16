class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :initiator_id, null: false
      t.integer :friend_id, null: false
      t.boolean :confirmed, null: false, default: false
      t.timestamps
    end
  end
end
