class AddSecretKeyColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :secret_key_p, :integer
    add_column :users, :secret_key_q, :integer
    add_column :users, :public_key_m, :integer
    add_column :users, :public_key_k, :integer
  end
end
