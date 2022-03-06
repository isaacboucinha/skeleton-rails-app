class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.citext :name, null: false

      t.datetime :discarded_at
      t.timestamps
    end

    add_index :accounts, :name, unique: true
  end
end
