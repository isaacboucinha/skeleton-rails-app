class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :account, null: false, foreign_key: true, type: :uuid
      
      t.decimal :balance, :default => 1000
      t.string :currency, :default => 'eur'
      t.boolean :active, :default => true
      t.timestamps
    end

    add_index :wallets, [:user_id, :account_id], unique: true
  end
end
