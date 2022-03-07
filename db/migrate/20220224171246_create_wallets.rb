class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      
      t.decimal :balance, :default => 1000
      t.string :currency, :default => 'eur'
      
      t.datetime :discarded_at
      t.timestamps
    end
  end
end
