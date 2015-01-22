class ChangeDataTypeForKeys < ActiveRecord::Migration
  def up
    change_column :users, :public_key_m, :integer, limit: 8
    change_column :users, :public_key_k, :integer, limit: 8
    change_column :users, :secret_key_p, :integer, limit: 8
    change_column :users, :secret_key_q, :integer, limit: 8
  end

  def down
    change_column :users, :public_key_m, :integer, limit: nil
    change_column :users, :public_key_k, :integer, limit: nil
    change_column :users, :secret_key_p, :integer, limit: nil
    change_column :users, :secret_key_q, :integer, limit: nil
  end
end
