class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name

      t.datetime :discarded_at
      t.timestamps
    end
  end
end
