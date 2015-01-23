class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :recipient_id, null: false
      t.integer :public_key_m, limit: 8, null: false
      t.integer :public_key_k, limit: 8, null: false
      t.text :body, null: false
      t.timestamps
    end
  end
end
