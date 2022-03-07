class CreateUsersAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :users_accounts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.datetime :discarded_at
      t.timestamps
    end

    add_index :users_accounts, [:user_id, :account_id], unique: true
  end
end
