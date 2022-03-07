class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      
      t.integer :balance, :default => MINIMUM_FOR_WALLET_CREATION
      t.string :currency, :default => 'eur'
      
      t.timestamps
    end
  end
end
