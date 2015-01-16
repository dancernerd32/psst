class ChangeInitiatorColumn < ActiveRecord::Migration
  def change
    rename_column :friendships, :initiator_id, :user_id
  end
end
