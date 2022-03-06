class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.text :name, null: false
      t.string :password_digest

      t.datetime :discarded_at
      t.timestamps
    end

    add_index :users, :name, unique: true
  end
end
