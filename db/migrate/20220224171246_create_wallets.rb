class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.belongs_to :user
      t.belongs_to :account
      t.decimal :balance
      t.string :currency
      t.timestamps
    end
  end
end
